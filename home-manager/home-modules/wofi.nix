{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;

    # Wofi Configuration (maps to ~/.config/wofi/config)
    settings = {
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = false;
      term = "kitty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";
      columns = 2;
      location = "top";
      y_offset = 100;
    };

    # Wofi Styling (maps to ~/.config/wofi/style.css)
    style = ''
      /* Color definitions from your style.css */
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      * {
        font-family: 'Inconsolata Nerd Font', monospace;
        font-size: 14px;
      }

      /* Window */
      window {
        margin: 0px;
        padding: 10px;
        border: 0.16em solid @lavender;
        border-radius: 2px;
        background-color: @base;
        animation: slideIn 0.1s ease-in-out both;
      }

      /* Slide In */
      @keyframes slideIn {
        0% {
          opacity: 0;
        }
        100% {
          opacity: 1;
        }
      }

      /* Inner Box */
      #inner-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
        border-radius: 2px;
        animation: fadeIn 0.1s ease-in-out both;
      }

      /* Fade In */
      @keyframes fadeIn {
        0% {
          opacity: 0;
        }
        100% {
          opacity: 1;
        }
      }

      /* Outer Box */
      #outer-box {
        margin: 5px;
        padding: 10px;
        border: none;
        background-color: @base;
        border-radius: 2px;
      }

      /* Scroll */
      #scroll {
        margin: 0px;
        padding: 10px;
        border: none;
        background-color: @base;
        border-radius: 2px;
      }

      /* Input - MODIFIED */
      #input {
        margin: 5px 20px;
        padding: 10px;
        border: none;
        border-radius: 2px;
        color: @text;
        background-color: @surface0; 
        animation: fadeIn 0.1s ease-in-out both;
      }
      
      /* ADDED: Remove the default GTK focus border/shadow when the input is active */
      #input:focus {
        border: none;
        box-shadow: none;
      }

      #input image {
        border: none;
        color: @red;
      }

      #input * {
        /* Removed the red outline in the previous turn */
        outline: none;
      }

      /* Text */
      #text {
        margin: 5px;
        border: none;
        color: @text;
        border-radius: 2px;
        animation: fadeIn 0.1s ease-in-out both;
      }

      #entry {
        background-color: @base;
        border-radius: 2px;
      }

      #entry arrow {
        border: none;
        color: @lavender;
      }

      /* Selected Entry */
      #entry:selected {
        background-color: @surface0; 
        border: none;
        border-radius: 2px;
      }

      #entry:selected #text {
        color: @mauve;
      }

      #entry:drop(active) {
        background-color: @lavender!important;
        border-radius: 2px;
      }
    '';
  };
}
