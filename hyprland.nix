{ config, pkgs, ... }:

{
  # Enable Hyprland system-wide
  programs.hyprland = {
    enable = true;

  };

  # PAM integration for hyprlock
  security.pam.services.hyprlock = {};
}

