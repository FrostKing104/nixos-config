{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      location = "center";
      allow_markup = true;
      show = "drun";
      hide_scroll = true;
      term = "kitty";
      allow_images = false;
      insensitive = true;
    };
    style = ''
      * {
        font-family: JetBrains Mono;
        font-size: 14px;
        color: #cdd6f4;
      }

      window {
        background-color: #1e1e2e;
        border: 3px solid #cba6f7;
        border-radius: 10px;
        padding: 10px;
      }

      #input {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-top: 3px solid #bac2de;
        border-right: 3px solid #bac2de;
        border-left: 3px solid #bac2de;
        border-bottom: none;
        padding: 6px;
      }


      #entry {
        padding: 6px;
      }

      #entry:selected {
        background-color: #cba6f7;
        color: #1e1e2e;
      }
    '';
  };
}
