# Edit this configuration file to define what should be installed on your system.  Help is available in the
# configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, lib, ... }:


let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
#  aagl = import (builtins.fetchTarball {
#    url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/release-25.05.tar.gz";
#    sha256 = "01nm4qvp6mbyc96ff2paccwcx0clvg1mvpxg5y6d17db9ds7j8kl";
 # });
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./packages.nix
      ./hyprland.nix
 #     aagl.module
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Enable 32 Bit (For Epic Games Store)
  hardware.graphics.enable32Bit = true;

  # GTK Configuration
  programs.dconf.enable = true;
  services.dbus.enable = true;
  
  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Enable iio sensor detection
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Playerctl
  services.playerctld.enable = true;

  # Enable Virtualisation
  virtualisation.libvirtd.enable = true;

  # Configure waydroid-helper
  # This is the corrected block
  environment.systemPackages = [ pkgs.waydroid-helper ];
  systemd = {
    # 1. Fixes the SYSTEM service (waydroid-mount.service)
    services.waydroid-mount = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # This is the fix: Replaces '/usr/bin/waydroid-helper'
        ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --start-mount";
      };
    };

    # 2. Fixes and enables the USER service (waydroid-monitor.service)
    user.services.waydroid-monitor = {
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        # This is the same fix for the user service
        ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --monitor";
      };
    };
  };


  # Tailscale

  # 1. Enable Tailscale service
  services.tailscale.enable = true;

  # 2. Configure Tailscale to handle routing features (subnet routes and exit nodes)
  services.tailscale.useRoutingFeatures = "server";
  
  # 3. Add the flag to the 'tailscale up' command, making the machine advertise itself as an Exit Node.
  services.tailscale.extraUpFlags = [ 
    "--advertise-exit-node"
  ];
  
  # 4. CRITICAL FIX: Allow WireGuard packets (Tailscale's tunnel) to pass through NixOS firewall
  # This prevents loss of internet when using the exit node.
  networking.firewall.checkReversePath = "loose";

  # 5. IP forwarding (The useRoutingFeatures="both" handles this, but explicit setup is safe)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # --- Garbage Collection (system configurations older than 30 days will be deleted weekly) --- #
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable Fstrim
  services.fstrim.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "catppuccin-mocha";
  
  services.desktopManager.plasma6.enable = true;

  # Enable OpenTabletDriver for pen tablets
  hardware.opentabletdriver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  # Specify Intel
  services.xserver.videoDrivers = [ "intel" ];

  # Enable experimental features
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https.ezkea.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  # Allow App Images to work properly
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Environment Variables
  environment.variables = {
    FZF_BASE = "${pkgs.fzf}/share/fzf";
  };

  # An Anime Game Launcher:
  #programs.anime-game-launcher.enable = true;
  #programs.anime-games-launcher.enable = true;
  #programs.honkers-railway-launcher.enable = false;
  #programs.honkers-launcher.enable = false;
  #programs.wavey-launcher.enable = false;
  #programs.sleepy-launcher.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable some programs for SUID wrappers
  # programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true; 

  # --- Waydroid Fix ---
  networking.firewall.extraForwardRules = "accept"; 
  networking.firewall.allowedTCPPorts = [ 4713 53 ]; 
  networking.firewall.allowedUDPPorts = [ 53 67 ];

  # FCITX5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc     # This should be here
      fcitx5-gtk
      fcitx5-tokyonight
      qt6Packages.fcitx5-configtool 
    ];
  };

  # NixOS release version for stateful data and default settings
  system.stateVersion = "24.11"; # Did you read the comment?
}
