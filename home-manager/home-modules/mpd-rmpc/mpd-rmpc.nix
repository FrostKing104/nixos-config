# ~/nixos-config/home-manager/home-modules/mpd-rmpc/mpd-rmpc.nix
{ config, pkgs, lib, ... }:
{
  # User-level MPD configuration (runs as your user, not system-wide)
  services.mpd = {
    enable = true;
    musicDirectory = "/home/anklus/Music/musicSync/";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };

  # Enable the MPRIS bridge for the MPD service
  services.mpd-mpris = {
    enable = true;
  };

  # rmpc configuration
  programs.rmpc = {
    enable = true;
    
    config = ''
      (
        address: "127.0.0.1:6600",
        cache_dir: Some("/home/anklus/.cache/rmpc"),
      )
    '';
  };

  # Create the theme file
  home.file.".config/rmpc/themes/catppuccinTheme.ron" = {
    text = builtins.readFile ./catppuccinTheme.ron;
  };
}
