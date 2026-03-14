nix shell nixpkgs#jq nixpkgs#colordiff -c bash -c "diff -u <(jq -S . ~/.config/noctalia/settings.json) <(jq -S . ~/.config/noctalia/gui-settings.json) | colordiff"
