# Edit this configuration file to define what should be installed on your system.  Help is available in the
# configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:


let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
  aagl = import (builtins.fetchTarball {
    url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/release-25.05.tar.gz";
    sha256 = "1ibx1q0idrnin70dsp3brqzd432b2xd0vg3pz1l31v8afzlg7rp2";
  });
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./packages.nix
      ./hyprland.nix
      aagl.module
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # --- Garbage Collection (system configurations older than 30 days will be deleted weekly) --- #
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
    fira-code
    dejavu_fonts
    font-awesome
    liberation_ttf
    ubuntu_font_family
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
    extraGroups = [ "networkmanager" "wheel" ];
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
    users.anklus = import ./home-manager/home.nix;
  };

  # Specify Intel
  services.xserver.videoDrivers = [ "intel" ];

  # Enable experimental features
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://ezkea.cachix.org" ];
    trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };
  # Environment Variables
  environment.variables = {
    FZF_BASE = "${pkgs.fzf}/share/fzf";
  };

  # An Anime Game Launcher:
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = false;
  programs.honkers-launcher.enable = false;
  programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable some programs for SUID wrappers
  # programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 4713 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
 
  # Disable the firewall altogether.
  # networking.firewall.enable = false;

  # File System Declaration
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c1dac6ea-8f0e-4759-873d-28de63e7e6d6";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/268D-58F3";
      fsType = "vfat";
    };

    "/games" = {
      device = "/dev/disk/by-uuid/460e9a24-b39c-4fce-859d-8ebf25e9f941";
      fsType = "ext4";
    };
  };

  # FCITX5
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc        # This should be here
      fcitx5-gtk
      fcitx5-tokyonight
      fcitx5-configtool
    ];
  };

  # NixOS release version for stateful data and default settings
  system.stateVersion = "24.11"; # Did you read the comment?
}
