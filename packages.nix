# ~/nixos-config/packages.nix
{ config, pkgs, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ----- System Programs (Modules) ----- #
  programs.firefox.enable = true; 
  programs.zsh.enable = true;
  programs.steam.enable = true; 
  programs.hyprland.enable = true; # Recommended over just putting package in list

  # ----- System Packages ----- #
  environment.systemPackages = with pkgs; [
    
    # ---- Hardware & Drivers ---- #
    brightnessctl
    ddcutil
    bluez
    blueman
    lm_sensors
    opentabletdriver
    lact
    thinkfan
    radeontop
    alsa-utils
    pavucontrol
    
    # ---- Core System Utilities ---- #
    gh
    git
    git-lfs
    git-credential-manager
    networkmanagerapplet
    syncthing
    tailscale
    sunshine
    gnome-keyring
    flatpak
    snixembed
    libnotify
    glib
    gsettings-desktop-schemas
    trash-cli
    file
    jq
    tree
    protonvpn-gui
    bat
    ffmpegthumbnailer
    imagemagick 
    ueberzugpp
    
    # ---- Display Manager & Theming Assets ---- #
    # (These must be system-wide for SDDM to see them)
    sddm-astronaut
    catppuccin-sddm
    catppuccin-sddm-corners
    catppuccin
    gnome-themes-extra
    gtk-engine-murrine
    
    # ---- Hyprland Core ---- #
    hyprlock
    hyprpaper
    hyprsunset
    swww
    waybar
    swaynotificationcenter
    wl-clipboard
    cliphist
    wtype
    slurp
    grim
    swappy
    
    # ---- Dependencies & Libraries ---- #
    cmake
    meson
    cpio
    freetype
    xorg.libXft
    cairo
    pango
    sassc
  ];

  # ----- System Services ----- #
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb; 
    motherboard = "amd"; 
    server.port = 6742;      
  };

  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
    packages = [
      "net.ankiweb.Anki"
      "net.waterfox.waterfox"
      "org.libretro.RetroArch"
      "com.usebottles.bottles"
    ];
    uninstallUnused = true;
  };
}
