#!/bin/bash
# ABINSTEIN OS Phase 1 boot bootstrap
# QEMU ARM64 startup orchestration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build"
KERNEL_IMAGE="${BUILD_DIR}/output/Image"
INITRD_IMAGE="${BUILD_DIR}/output/initramfs.cpio.gz"
QEMU_BIN="${QEMU_BIN:-$(command -v qemu-system-aarch64 || true)}"

log() { echo "[PHASE1] $*"; }

require_tool() {
    local tool="$1"
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[PHASE1][ERROR] Missing required tool: $tool" >&2
        exit 1
    fi
}

ensure_dirs() {
    mkdir -p "${BUILD_DIR}/output" "${BUILD_DIR}/logs"
}

configure_qemu_kernel() {
    log "Preparing QEMU ARM64 boot image"
    if [[ -f "${KERNEL_IMAGE}" ]]; then
        return 0
    fi
    if [[ -f "${PROJECT_ROOT}/build_os.sh" ]]; then
        bash "${PROJECT_ROOT}/build_os.sh" qemu || {
            echo "[PHASE1][ERROR] build_os.sh qemu failed" >&2
            exit 1
        }
    fi
}

boot_qemu() {
    if [[ -z "${QEMU_BIN}" ]]; then
        echo "[PHASE1][ERROR] qemu-system-aarch64 not found" >&2
        exit 1
    fi
    if [[ ! -f "${KERNEL_IMAGE}" ]]; then
        echo "[PHASE1][ERROR] Kernel image missing: ${KERNEL_IMAGE}" >&2
        exit 1
    fi
    if [[ ! -f "${INITRD_IMAGE}" ]]; then
        echo "[PHASE1][ERROR] Initramfs missing: ${INITRD_IMAGE}" >&2
        exit 1
    fi

    log "Booting ABINSTEIN OS under QEMU"
    exec "${QEMU_BIN}" \
        -machine virt \
        -cpu cortex-a53 \
        -smp 2 \
        -m 1024 \
        -kernel "${KERNEL_IMAGE}" \
        -initrd "${INITRD_IMAGE}" \
        -append "root=/dev/ram rw console=ttyAMA0 console=tty0" \
        -serial stdio \
        -display none \
        -no-reboot
}

main() {
    require_tool bash
    require_tool qemu-system-aarch64
    ensure_dirs
    configure_qemu_kernel
    boot_qemu
}

main "$@"
