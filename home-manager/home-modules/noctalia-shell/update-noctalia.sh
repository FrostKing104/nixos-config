#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Exporting Noctalia settings to JSON..."
noctalia-shell ipc call state all > ~/nixos-config/home-manager/home-modules/noctalia-shell/noctalia.json
echo "Done! Rebuild to see the changes go into effect."
