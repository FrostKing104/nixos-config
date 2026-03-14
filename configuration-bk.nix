# Edit this configuration file to define what should be installed on your system.  Help is available in the
# configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, lib, ... }:

{
  # --- Imports --- #
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./packages.nix
      ./hyprland.nix
      ./sddm.nix
    ];

  # --- Bootloader & Kernel --- #
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  # 5. IP forwarding (The useRoutingFeatures="both" handles this, but explicit setup is safe)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # --- Networking & Firewall --- #
  networking = {
    hostName = "framework"; # Define your hostname.
    networkmanager.enable = true;
    # Open ports in the firewall
    firewall = {
      enable = true;
      extraForwardRules = "accept";
      allowedTCPPorts = [ 4713 53 ];
      allowedUDPPorts = [ 53 67 ];
    };
  };

  # This prevents loss of internet when using the tailscale exit node.
  networking.firewall.checkReversePath = "loose";

  # --- Hardware Support (GPU, Sound, Bluetooth, etc.) --- #
  # Enable Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Enable 32 Bit (For Epic Games Store)
  hardware.graphics.enable32Bit = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable iio sensor detection
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Enable OpenTabletDriver for pen tablets
  hardware.opentabletdriver.enable = true;

  # Specify Intel
  services.xserver.videoDrivers = [ "intel" ];

  # --- System Services --- #
  # GTK Configuration
  programs.dconf.enable = true;
  services.dbus.enable = true;

  # Shell #
  services.noctalia-shell.enable = true;

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Playerctl
  services.playerctld.enable = true;

  # Enable Virtualisation
  virtualisation.libvirtd.enable = true;

  # Configure waydroid-helper
  #environment.systemPackages = [ pkgs.waydroid-helper ];
  #systemd = {
  #  # 1. Fixes the SYSTEM service (waydroid-mount.service)
  #  services.waydroid-mount = {
  #    wantedBy = [ "multi-user.target" ];
  #    serviceConfig = {
  #      # This is the fix: Replaces '/usr/bin/waydroid-helper'
  #      ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --start-mount";
  #    };
  #  };

    # 2. Fixes and enables the USER service (waydroid-monitor.service)
  #  user.services.waydroid-monitor = {
  #    wantedBy = [ "graphical-session.target" ];
  #    serviceConfig = {
  #      # This is the same fix for the user service
  #      ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --monitor";
  #    };
  #  };
  #};

  # Tailscale
  services.tailscale = { 
    enable = true;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
    ];
  };

  # Enable Fstrim
  services.fstrim.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # --- X11 & Desktop Environment --- #
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # --- Users & Home Manager --- #
  # Define a user account.
  users.users.anklus = {
    isNormalUser = true;
    description = "Anklus";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.anklus = import ./home-manager/home.nix;
  };

  # --- Localisation & Fonts --- #
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # FCITX5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-tokyonight
      qt6Packages.fcitx5-configtool
    ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    fira-code
    dejavu_fonts
    font-awesome
    liberation_ttf
    ubuntu-classic
    jetbrains-mono
    source-han-sans
    source-han-serif
    vista-fonts
    vista-fonts-chs
  ];

  # Font Rendering and Fallback Settings (system-wide)
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";  # Try "none" or "full" if this doesn't look good
    };
    subpixel.rgba = "rgb";
    defaultFonts = {
      serif = [ "Liberation Serif" "Noto Serif CJK JP" "Source Han Serif" ];
      sansSerif = [ "Ubuntu" "Noto Sans CJK JP" "Source Han Sans" ];
      monospace = [ "JetBrains Mono" "Noto Sans Mono CJK JP" ];
    };
  };

  # --- Nix Settings & GC --- #
  # Enable experimental features
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://ezkea.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- Garbage Collection (system configurations older than 30 days will be deleted weekly) --- #
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 20d";
  };

  # --- Environment Variables & Programs --- #
  # Allow App Images to work properly
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Environment Variables
  environment.variables = {
    FZF_BASE = "${pkgs.fzf}/share/fzf";
  };

  # An Anime Game Launcher:
  # programs.anime-game-launcher.enable = true;
  # programs.anime-games-launcher.enable = true;
  # programs.honkers-railway-launcher.enable = false;
  # programs.honkers-launcher.enable = false;
  # programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = false;

  # Enable some programs for SUID wrappers
  # programs.mtr.enable = true;

  # --- System State --- #
  # NixOS release version for stateful data and default settings
  system.stateVersion = "24.11"; # Did you read the comment?
}

