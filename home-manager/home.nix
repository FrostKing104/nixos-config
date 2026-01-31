{ config, pkgs, inputs, ... }:

{
  # IMPORTS
  imports = [
    # REMOVED: inputs.catppuccin.homeModules.catppuccin - this is handled in catppuccin.nix
    ./home-modules/wofi.nix
    ./home-modules/packages.nix
    ./home-modules/fcitx5.nix
    ./home-modules/catppuccin.nix
    ./home-modules/desktopShortcuts.nix
    ./home-modules/noctalia-shell.nix
    ./home-modules/quickshell.nix
    ./home-modules/zsh/zsh.nix
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

 # GTK Configuration 
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 11;
    };
#    theme = {
#      package = pkgs.gnome-themes-extra;
#      name = "Adwaita-dark";  # Use dark variant
#    };
#    iconTheme = {
#      package = pkgs.adwaita-icon-theme;
#      name = "Adwaita";
#    };
  };

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
    TERMINAL = "kitty";
    DEFAULT_BROWSER = "firefox";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Terminal
      "x-scheme-handler/terminal" = [ "kitty.desktop" ];
      "terminal-emulator" = [ "kitty.desktop" ];
      "x-terminal-emulator" = [ "kitty.desktop" ];
      # Web 
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      # Images
      "image/jpeg" = [ "swappy.desktop" ];
      "image/png" = [ "swappy.desktop" ];
      "image/webp" = [ "swappy.desktop" ];
    };
  };

  # Custom swappy .desktop for automatic image opening
  xdg.desktopEntries.swappy = {
    name = "Swappy";
    genericName = "Image Editor";
    exec = "swappy -f %f"; # The %f tells Swappy to take the file path as an argument
    icon = "swappy";
    terminal = false;
    categories = [ "Graphics" ];
    mimeType = [ "image/png" "image/jpeg" "image/jpg" "image/webp" ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".icons/Dracula-cursors" = {
    source = ./Dracula-cursors;
    recursive = true;
  };
}
