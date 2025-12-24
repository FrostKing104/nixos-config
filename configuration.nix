# Edit this configuration file to define what should be installed on your system.  Help is available in the
# configuration.nix(5) man page and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, ... }:


let
#  aagl = import (builtins.fetchTarball {
#    url = "github:ezYakaPaka/aagl-gtk-on-nix/release-25.11.tar.gz";
#    sha256 = "01nm4qvp6mbyc96ff2paccwcx0clvg1mvpxg5y6d17db9ds7j8kl";
#  });
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./packages.nix
      ./hyprland.nix
#      aagl.module
      ./ai.nix
      ./nextcloud.nix
    ];

  # ----- TEMP ----- #
  services.noctalia-shell.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  # For fans
  boot.kernelModules = [ "nct6775" ];

  networking.hostName = "desktop"; # Define your hostname.
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

  # Playerctl
  services.playerctld.enable = true;

  # OpenSSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true; 
    openFirewall = false;
  };
  
  # Enable Virtualisation
  virtualisation.libvirtd.enable = true;

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
    dates = "daily";
    options = "--delete-older-than 20d";
  };

  # Enable Fstrim
  services.fstrim.enable = true;

  # --- Fan Control Configuration --- #

  services.thinkfan = {
    enable = true;
    settings = {
      # Define the temperature sensors
      sensors = [
        # Sensor 0: CPU Temperature (Ryzen 5 3600)
        {
          type = "hwmon";
          query = "/sys/devices/pci0000:00/0000:00:18.3"; # k10temp
          indices = [ 1 ]; # Use temp1_input (Tctl/Tdie)
        }
        # Sensor 1: GPU Temperature (Radeon RX 580)
        {
          type = "hwmon";
          query = "/sys/devices/pci0000:00/0000:00:03.1/0000:06:00.0"; # amdgpu
          indices = [ 1 ]; # Use temp1_input (Edge)
        }
        # Sensor 2: Motherboard Temperature (ASRock B450M)
        {
          type = "hwmon";
          query = "/sys/devices/platform/nct6775.656"; # nct6798 chip
          # FIXED: Use index 2 (temp2_input / CPUTIN)
          indices = [ 2 ]; 
        }
      ];

      # Define the fan controllers
      fans = [
        # CPU Fan Controller
        {
          type = "hwmon";
          query = "/sys/devices/platform/nct6775.656"; # Fans are on the mobo chip
          # FIXED: Use index 2 (pwm2) to control fan2
          indices = [ 2 ]; 
        }
      ];

      # Define the fan curve (Complex Mode)
      # The sensor order matches the `sensors` block above: [CPU, GPU, Motherboard]
      levels = [
      # Fan PWM, [CPU Temp Range], [GPU Temp Range], [Mobo Temp Range]
      # Off/Idle (PWM 0/255 -> 0%)
        { speed = 0; upper_limit = [ 55 58 50 ]; }
      # Low Speed (PWM 53/255 -> ~20%)
        { speed = 53; lower_limit = [ 53 56 48 ]; upper_limit = [ 65 68 55 ]; }
      # Medium Speed (PWM 128/255 -> 50%)
        { speed = 128; lower_limit = [ 63 66 53 ]; upper_limit = [ 75 78 60 ]; }
      # High Speed (PWM 191/255 -> 75%)
        { speed = 191; lower_limit = [ 73 76 58 ]; upper_limit = [ 85 88 65 ]; }
      # Full Speed (PWM 255/255 -> 100%)
        { speed = 255; lower_limit = [ 83 86 63 ]; upper_limit = [ 255 255 255 ]; }
      ];
    };
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
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    fira-code
    dejavu_fonts
    font-awesome
    liberation_ttf
    jetbrains-mono
    ubuntu-classic
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
  services.displayManager.sddm.theme = "catppuccin-mocha_mauve";
  
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
  #services.xserver.videoDrivers = [ "intel" ];

  # Enable experimental features
  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://ezkea.cachix.org" ];
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
  #programs.anime-games-launcher.enable = false;
  #programs.honkers-railway-launcher.enable = false;
  #programs.honkers-launcher.enable = false;
  #programs.wavey-launcher.enable = false;
  #programs.sleepy-launcher.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable some programs for SUID wrappers
  # programs.mtr.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 4713 8080 8000 ];
    trustedInterfaces = [ "docker0" "tailscale0" ];
  };
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
      fcitx5-mozc        
      fcitx5-gtk
      fcitx5-tokyonight
      qt6Packages.fcitx5-configtool
    ];
  };

  # NixOS release version for stateful data and default settings
  system.stateVersion = "24.11"; # Did you read the comment?
}
