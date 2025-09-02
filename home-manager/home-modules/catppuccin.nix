{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    # enable = true;
    flavor = "mocha";  # or "latte", "frappe", "macchiato"
    accent = "lavender";   # or other accent colors
    
    # REMOVED: gtk.enable = true; - This option no longer exists
    
    # You can enable other components
    chromium.enable = true;


    cava = {
      enable = true;
      flavor = "mocha";
      transparent = true;
    };

    hyprlock = {
      enable = true;
      useDefaultConfig = true;
    };

  };
}
