# ~/nixos-config/hyprland.conf
{ config, pkgs, ... }:

{

  # Install Ollama
  services.ollama = {
    enable = true;
    # Make Ollama accessible from network
    host = "0.0.0.0";  # Listen on all interfaces
  };

  # Install Open WebUI
  services.open-webui = {
    enable = true;
    port = 8080;
    host = "0.0.0.0";
  };

  virtualisation.docker.enable = true;
}

