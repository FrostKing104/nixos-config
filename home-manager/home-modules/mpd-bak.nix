{ config, pkgs, lib, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/anklus/Music/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };
  
  programs.rmpc = {
    enable = true;
    config = ''
      (
        address: "127.0.0.1:6600",
        cache_dir: Some("/home/anklus/.cache/rmpc")
      )
    '';
  }; 

  # USE systemd.user.services to configure the user-level systemd unit
  systemd.user.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000"; 
  };
}
