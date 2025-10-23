# ~/nixos-config/packages.nix
{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable programs
  programs.firefox.enable = true; 
  programs.zsh.enable = true;
  programs.steam.enable = true; 

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    kitty
    hyprlock
    fastfetch
    networkmanagerapplet
    git
    syncthing
    git-credential-manager
    rofi
    brightnessctl
    hyprland
    zsh
    tree
    wofi
    waybar
    swaynotificationcenter
    blueman
    cmake
    meson
    cpio
    freetype
    xorg.libXft
    cairo
    pango
    bluez
    localsend
    hyprpaper
    hyprsunset
    gnome-keyring
    oh-my-zsh
    pamixer
    jq
    slurp
    grim
    wl-clipboard
    libnotify
    swappy
    glib
    signal-desktop
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    catppuccin-sddm
    catppuccin-sddm-corners
    catppuccin
    nwg-look
    zsh-powerlevel10k
    fzf-zsh
    zsh-autosuggestions
    zsh-git-prompt
    zsh-syntax-highlighting
    zsh-history-substring-search
    vesktop
    flatpak
    pavucontrol
    swww
    tailscale
    sunshine
    # GTK
    gnome-themes-extra
    gtk-engine-murrine
    gsettings-desktop-schemas
    glib
    # -
    gh
    mpv
    ddcutil
    playerctl
    wtype
    # Screenshots
    swappy
    grim
    slurp
    # Wayland Clipboard Manager
    cliphist
    file
    yazi
    brave
    lm_sensors
    opentabletdriver
    commitizen
    git-lfs
    lazygit
  ];

  services.hardware.openrgb.enable = true;


  services.flatpak = {
    enable = true;
    packages = [
      #"app.zen_browser.zen"    
      "net.ankiweb.Anki"
      "net.waterfox.waterfox"
      "org.libretro.RetroArch"
    ];
    uninstallUnused = true;
  };
}
