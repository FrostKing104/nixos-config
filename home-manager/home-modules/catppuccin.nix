{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    ## This would enable catppuccin globally - perhaps good for a new build, but not an established one
    # enable = true;
    flavor = "mocha";  # or "latte", "frappe", "macchiato"
    accent = "mauve";   
    
    # Specific programs

    chromium = {
      enable = true;
      flavor = "mocha";
    };

    element-desktop = {
      enable = true;
      accent = "green";
    };

    cava = {
      enable = true;
      flavor = "mocha";
      transparent = true;
    };

    obs = {
      enable = true;
      flavor = "mocha";
    };

    opencode = {
      enable = true;
      flavor = "mocha";
    };

    hyprlock = {
      enable = true;
      useDefaultConfig = true;
    };

  };
}
