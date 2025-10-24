{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Add hyprgrass plugin from nixpkgs
    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];
    
    # Source your existing dotfiles configuration
    # This allows you to keep editing your dotfiles without rebuilding
    extraConfig = ''
      # Source your main config from dotfiles
    '';
  };
}

