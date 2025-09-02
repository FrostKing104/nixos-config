# ~/nixos-config/hyprland.conf
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
  };
  
  # Use hyprlock
  security.pam.services.hyprlock = {};

}
