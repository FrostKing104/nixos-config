{ config, pkgs, ... }:

{
  # Since you are running NixOS with Hyprland (based on our saved info),
  # this wofi configuration is highly relevant for your setup.
  programs.wofi = {
    enable = true;

    # Wofi Configuration (maps to ~/.config/wofi/config)
    settings = {
      # From your wofi config
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true; # Note: not always needed, but included
      show_all = false;         # Note: not always needed, but included
      term = "kitty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";              # Explicitly set to empty string
      columns = 2;

      # Vim Keybindings (Wofi uses these names in the config file)
      key_up = "k";
      key_down = "j";
      key_left = "h";
      key_right = "l";
    };

    # Wofi Styling (maps to ~/.config/wofi/style.css)
    # The CSS is wrapped in a multi-line string.
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
        border-radius: 0.1em;
        background-color: @base;
        /* Animation properties are sometimes problematic in CSS embedded in NixOS,
           but including them for completeness. */
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
      }

      /* Scroll */
      #scroll {
        margin: 0px;
        padding: 10px;
        border: none;
        background-color: @base;
      }

      /* Input */
      #input {
        margin: 5px 20px;
        padding: 10px;
        border: none;
        border-radius: 0.1em;
        color: @text;
        background-color: @base;
        animation: fadeIn 0.1s ease-in-out both;
      }

      #input image {
        border: none;
        color: @red;
      }

      #input * {
        /* You had !important, which is supported in CSS but sometimes
           can be tricky. Kept for fidelity. */
        outline: 4px solid @red!important;
      }

      /* Text */
      #text {
        margin: 5px;
        border: none;
        color: @text;
        animation: fadeIn 0.1s ease-in-out both;
      }

      #entry {
        background-color: @base;
      }

      #entry arrow {
        border: none;
        color: @lavender;
      }

      /* Selected Entry */
      #entry:selected {
        border: 0.11em solid @lavender;
      }

      #entry:selected #text {
        color: @mauve;
      }

      #entry:drop(active) {
        background-color: @lavender!important;
      }
    '';
  };
}
