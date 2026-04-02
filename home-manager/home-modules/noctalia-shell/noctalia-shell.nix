{ pkgs, inputs, ... }:

let
  importedSettings = builtins.fromJSON (builtins.readFile ./noctalia.json);
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  # Fix for KDE notification watcher stealing notifications from the shell
  systemd.user.services.plasma-kded6 = {
    Unit = {
      # Prevents the daemon from starting in Hyprland - Will only start in kde
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=KDE";
    };
  };

  programs.noctalia-shell = {
    enable = true;

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        "assistant-panel" = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        "mini-docker" = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        pomodoro = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        "screen-recorder" = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
    
    pluginSettings = {
      tailscale = {
        showIpAddress = true;
        showPeerCount = false;
        refreshInterval = 5000;
        compactMode = false;
        defaultPeerAction = "copy-id";
        hideDisconnected = false;
        pingCount = 5;
        terminalCommand = "kitty";
      };
      
      "assistant-panel" = {
        showIcon = true;
        ai = {
          provider = "google";
          model = "gemini-2.5-flash";
          systemPrompt = ''
            You are a smart assistant integrated into a Linux desktop shell.

            USER PROFILE:
            - Identity: Computer Science student at GSU Perimeter College (Newton Campus).
            - Background: Self-taught/homeschooled; prefers direct technical answers without "hand-holding."
            - Location: Loganville, GA.

            SYSTEM CONFIGURATION:
            - OS: NixOS 25.11 (Xantusia) | Kernel: Linux 6.12.
            - Window Manager: Hyprland 0.52.1 (Wayland). Note: KDE Plasma is installed but strictly unused.
            - Hardware Specs:
              - CPU: AMD Ryzen 5 3600 (6-core/12-thread @ 3.6GHz).
              - GPU: AMD Radeon RX 580 2048SP (Discrete).
              - RAM: 16GB (2x8GB, ddr4).
              - Display: 1920x1080 @ 60Hz.
          - Keyboard: Custome Corne 4.1, managed with Vial

            GUIDELINES:
            1. NixOS Context: Assume a declarative system (configuration.nix/home-manager) for all software advice.
            2. Silence on Distro: Do not explicitly mention "As a NixOS user" unless the distinction is critical for the specific error being discussed.
            3. Brevity: Keep responses concise and optimized for a terminal/coding workflow.
            4. Hyprland: Assume standard Hyprland config files (.conf) for UI adjustments.
          '';
          apiKeys = {
            google = "";
          };
        };
      };

      "mini-docker" = {
        socketPath = "/var/run/docker.sock";
        refreshInterval = 2000;
      };
    };

    settings = importedSettings.settings;
  };
}
