#!/usr/bin/env bash

echo " [1/5] Stopping conflicting KDE services..."
systemctl --user stop plasma-kded6 2>/dev/null
pkill kded6 2>/dev/null

echo " [2/5] Stopping current Shell and Tray Bridge..."
pkill -f noctalia-shell
pkill -f snixembed

# Ensure processes are dead
sleep 1

echo " [3/5] Starting Legacy Bridge (snixembed)..."
# We redirect output to /dev/null to hide the Gtk-CRITICAL errors
snixembed > /dev/null 2>&1 & disown

echo " [4/5] Waiting 2 seconds for D-Bus to settle..."
sleep 2

echo " [5/5] Starting Noctalia Shell..."
noctalia-shell > /dev/null 2>&1 & disown

# Verification
sleep 1
if pgrep -f "noctalia-shell" > /dev/null; then
    echo " [✔] Success! Shell is running. Check your bar."
else
    echo " [✘] Error: Noctalia Shell failed to start."
fi
