#!/bin/bash
# ABINSTEIN OS - Script de pornire automata (Init)

echo "[ABINSTEIN OS] Telefonul se aprinde..."
echo "[ABINSTEIN OS] Se încarcă driverele video din HAL..."

# 1. Pornește serviciul grafic (Wayland)
wayland-compositor --backend=drm &

# 2. Așteaptă o secundă ca ecranul să fie gata
sleep 1

# 3. Deschide DIRECT interfața creată de tine în folderul launcher
echo "[ABINSTEIN OS] Se deschide Ecranul Principal (Launcher)..."
qml6runner /docs/launcher/main.qml --fullscreen
