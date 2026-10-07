# ABINSTEIN OS Phase 1-2 Readme

## Overview
ABINSTEIN OS Phase 1-2 adds the boot chain and system service foundation:
- boot bootstrap for QEMU ARM64
- initramfs early init
- rootfs rcS startup
- HAL display and power abstraction
- socket-based D-Bus service examples

## Requirements
Install the following packages:

```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential cmake git curl wget tar xz-utils bc \
    qemu-system-arm gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
```

## Build
```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
```

## Quick start
```bash
./build_os.sh qemu
```

## Boot Flow
- `scripts/phase1_boot.sh` orchestrates the QEMU startup
- `initramfs/init` mounts `/proc`, `/sys`, `/dev`, `/run`
- `rootfs/etc/init.d/rcS` loads the early userspace environment
- HAL exposes display and power information to services
- socket service listens on port `9000`

## Troubleshooting
- Missing QEMU: `sudo apt-get install qemu-system-arm`
- Missing cross compiler: `sudo apt-get install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu`
- Check build logs under `build/logs/`

## Next phases
Phase 3-7 continue with shell UI, apps, networking, audio, and camera services.
