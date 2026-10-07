#!/bin/bash
# ABINSTEIN OS Complete Build System
# Builds Linux kernel, rootfs, and bootable images for QEMU and Samsung Galaxy A20e

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUT_DIR="${BUILD_DIR}/output"
SOURCES_DIR="${BUILD_DIR}/sources"
TOOLS_DIR="${BUILD_DIR}/tools"
CACHE_DIR="${BUILD_DIR}/cache"
LOG_DIR="${BUILD_DIR}/logs"

CROSS_COMPILE="aarch64-linux-gnu-"
CROSS_CC="${CROSS_COMPILE}gcc"
CROSS_OBJCOPY="${CROSS_COMPILE}objcopy"
KERNEL_VERSION="6.1.92"
BUSYBOX_VERSION="1.36.1"
BUSYBOX_URL="https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz"

QEMU_CPU="cortex-a53"
QEMU_MEMORY="1024"
QEMU_CORES="2"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[ABINSTEIN]${NC} $*"; }
err() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
info() { echo -e "${BLUE}[INFO]${NC} $*"; }

check_requirements() {
    local missing_tools=()
    if ! command -v "${CROSS_CC}" >/dev/null 2>&1; then
        missing_tools+=("aarch64-linux-gnu-gcc")
    fi
    for tool in make cmake git curl wget tar gzip bzip2 xz bc qemu-system-aarch64; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        err "Missing required tools: ${missing_tools[*]}"
    fi
    log "Requirements satisfied"
}

setup_directories() {
    mkdir -p "${BUILD_DIR}" "${OUT_DIR}" "${SOURCES_DIR}" "${TOOLS_DIR}" "${CACHE_DIR}" "${LOG_DIR}"
    log "Build directories ready"
}

configure_qemu_kernel() {
    local kernel_dir="${SOURCES_DIR}/linux-${KERNEL_VERSION}"
    if [[ ! -d "${kernel_dir}" ]]; then
        return 0
    fi

    cd "${kernel_dir}"
    make ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" defconfig >/dev/null 2>&1 || true
    cat >> .config <<'EOF'
CONFIG_ARCH_VIRT=y
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_BLK=y
CONFIG_VIRTIO_NET=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_TMPFS=y
CONFIG_EXT4_FS=y
CONFIG_DRM=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
EOF
    make ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" olddefconfig >/dev/null 2>&1 || true
    cd "${SCRIPT_DIR}"
}

build_kernel() {
    log "Building Linux kernel ${KERNEL_VERSION}"
    local kernel_dir="${SOURCES_DIR}/linux-${KERNEL_VERSION}"
    local kernel_archive="${CACHE_DIR}/linux-${KERNEL_VERSION}.tar.xz"

    if [[ ! -d "${kernel_dir}" ]]; then
        curl -L "${KERNEL_URL}" -o "${kernel_archive}"
        tar -xf "${kernel_archive}" -C "${SOURCES_DIR}"
    fi

    cd "${kernel_dir}"
    configure_qemu_kernel
    make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE="${CROSS_COMPILE}" Image > "${LOG_DIR}/kernel-build.log" 2>&1 || err "Kernel build failed. See ${LOG_DIR}/kernel-build.log"
    cp arch/arm64/boot/Image "${OUT_DIR}/Image" || err "Failed to copy kernel image"
    log "Kernel built successfully: ${OUT_DIR}/Image"
    cd "${SCRIPT_DIR}"
}

build_busybox() {
    log "Building BusyBox ${BUSYBOX_VERSION}"
    local busybox_dir="${SOURCES_DIR}/busybox-${BUSYBOX_VERSION}"
    local busybox_archive="${CACHE_DIR}/busybox-${BUSYBOX_VERSION}.tar.bz2"

    if [[ ! -f "${busybox_archive}" ]]; then
        curl -L "${BUSYBOX_URL}" -o "${busybox_archive}"
    fi
    if [[ ! -d "${busybox_dir}" ]]; then
        tar -xf "${busybox_archive}" -C "${SOURCES_DIR}"
    fi

    cd "${busybox_dir}"
    make CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 defconfig >/dev/null 2>&1
    sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
    make -j"$(nproc)" CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 > "${LOG_DIR}/busybox-build.log" 2>&1 || err "BusyBox build failed"
    make CROSS_COMPILE="${CROSS_COMPILE}" ARCH=arm64 CONFIG_PREFIX="${OUT_DIR}/rootfs" install >/dev/null 2>&1
    log "BusyBox installed to ${OUT_DIR}/rootfs"
    cd "${SCRIPT_DIR}"
}

build_rootfs() {
    log "Creating root filesystem"
    local rootfs="${OUT_DIR}/rootfs"
    mkdir -p "${rootfs}/bin" "${rootfs}/sbin" "${rootfs}/etc/init.d" "${rootfs}/proc" "${rootfs}/sys" "${rootfs}/dev" "${rootfs}/tmp" "${rootfs}/run" "${rootfs}/var/log" "${rootfs}/var/run" "${rootfs}/root" "${rootfs}/home"

    cat > "${rootfs}/etc/fstab" <<'EOF'
proc    /proc   proc    defaults  0  0
sysfs   /sys    sysfs   defaults  0  0
tmpfs   /tmp    tmpfs   defaults  0  0
EOF
    echo "abinstein-qemu" > "${rootfs}/etc/hostname"
    cat > "${rootfs}/etc/inittab" <<'EOF'
::sysinit:/etc/init.d/rcS
::respawn:/bin/sh
::ctrlaltdel:/sbin/reboot
EOF

    cat > "${rootfs}/etc/init.d/rcS" <<'EOF'
#!/bin/sh
set -eu

echo "[INIT] Mounting filesystems..."
mount -t proc proc /proc 2>/dev/null || true
mount -t sysfs sysfs /sys 2>/dev/null || true
mount -t devtmpfs devtmpfs /dev 2>/dev/null || true
mkdir -p /dev/pts /run /tmp /var/log /var/run
mount -t devpts devpts /dev/pts 2>/dev/null || true
mount -t tmpfs tmpfs /run 2>/dev/null || true
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export HOME=/root

echo "[INIT] ABINSTEIN OS boot complete"
EOF
    chmod +x "${rootfs}/etc/init.d/rcS"

    if [[ ! -e "${rootfs}/sbin/init" ]]; then
        ln -sf ../bin/busybox "${rootfs}/sbin/init" 2>/dev/null || true
    fi

    log "Rootfs ready"
}

build_initramfs() {
    log "Building initramfs"
    local initramfs_dir="${OUT_DIR}/initramfs"
    rm -rf "${initramfs_dir}"
    cp -a "${OUT_DIR}/rootfs" "${initramfs_dir}"
    if [[ -f "${SCRIPT_DIR}/initramfs/init" ]]; then
        cp "${SCRIPT_DIR}/initramfs/init" "${initramfs_dir}/init"
        chmod +x "${initramfs_dir}/init"
    fi
    cd "${initramfs_dir}"
    find . -print0 | cpio -0 -H newc -o | gzip -9 > "${OUT_DIR}/initramfs.cpio.gz"
    cd "${SCRIPT_DIR}"
    log "Initramfs ready: ${OUT_DIR}/initramfs.cpio.gz"
}

boot_qemu() {
    local kernel="${OUT_DIR}/Image"
    local initramfs="${OUT_DIR}/initramfs.cpio.gz"

    if [[ ! -f "${kernel}" ]]; then err "Kernel image missing: ${kernel}"; fi
    if [[ ! -f "${initramfs}" ]]; then err "Initramfs missing: ${initramfs}"; fi

    log "Launching QEMU ARM64"
    qemu-system-aarch64 \
        -machine virt \
        -cpu cortex-a53 \
        -smp "${QEMU_CORES}" \
        -m "${QEMU_MEMORY}" \
        -kernel "${kernel}" \
        -initrd "${initramfs}" \
        -append "root=/dev/ram rw console=ttyAMA0 console=tty0" \
        -serial stdio \
        -display none \
        -no-reboot
}

show_usage() {
    cat <<'EOF'
Usage: ./build_os.sh [check|kernel|rootfs|initramfs|qemu]

Targets:
  check       Validate required tools
  kernel      Build ARM64 Linux kernel
  rootfs      Prepare root filesystem
  initramfs   Build initramfs archive
  qemu        Full QEMU ARM64 build and boot
EOF
}

case "${1:-help}" in
    check)
        check_requirements
        ;;
    kernel)
        setup_directories
        check_requirements
        build_kernel
        ;;
    rootfs)
        setup_directories
        build_rootfs
        ;;
    initramfs)
        setup_directories
        build_rootfs
        build_initramfs
        ;;
    qemu)
        setup_directories
        check_requirements
        build_kernel
        build_busybox
        build_rootfs
        build_initramfs
        boot_qemu
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        err "Unknown target: ${1:-}"
        ;;
esac

log "Done"




























































































































































































































































