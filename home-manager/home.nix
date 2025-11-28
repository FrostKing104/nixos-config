{ config, pkgs, inputs, ... }:

{
  # IMPORTS
  imports = [
    # REMOVED: inputs.catppuccin.homeModules.catppuccin - this is handled in catppuccin.nix
    ./wofi.nix
    ./home-modules/packages.nix
    ./home-modules/fcitx5.nix
    ./home-modules/catppuccin.nix
    ./home-modules/desktopShortcuts.nix
    ./home-modules/zsh.nix    
    ./home-modules/quickshell.nix
    ./home-modules/nixvim/nixvim.nix
    ./home-modules/mpd-rmpc/mpd-rmpc.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anklus";
  home.homeDirectory = "/home/anklus";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # GTK Configuration (back to manual since Catppuccin GTK is removed)
 # gtk = {
 #   enable = true;
 #   font = {
 #     name = "Ubuntu";
 #     size = 11;
 #   };
 #   theme = {
 #     package = pkgs.gnome-themes-extra;
 #     name = "Adwaita-dark";  # Use dark variant
 #   };
 #   iconTheme = {
 #     package = pkgs.adwaita-icon-theme;
 #     name = "Adwaita";
 #   };
 # };

  # DConf settings for GTK font rendering
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Ubuntu 11";
      document-font-name = "Ubuntu 11";
      monospace-font-name = "JetBrains Mono 10";
      font-antialiasing = "rgba";
      font-hinting = "slight";
    };
  };

  # Custom Added Fonts
        #Tartine Script
  home.file.".local/share/fonts/TartineScript-Regular.ttf" = {
    # The path is now a Nix path literal, not a string, and has no spaces.
    source = ./fonts/TartineScript-Regular.ttf; 
  };
  home.file.".local/share/fonts/Kugile.ttf" = {
    source = ./fonts/Kugile.ttf;
  };

  fonts.fontconfig.enable = true;

  # Environment variables for better GTK rendering
  home.sessionVariables = {
    #GTK_THEME = "Adwaita:dark";  # Back to manual GTK theme
    GDK_SCALE = "1";
    #GDK_DPI_SCALE = "1";
    # Make Firefox use Wayland when available, as opposed to XWayland
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".icons/Dracula-cursors" = {
    source = ./Dracula-cursors;
    recursive = true;
  };
}
