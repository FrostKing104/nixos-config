# ~/nixos-config/home-manager/home-modules/packages.nix
{ config, pkgs, inputs, ... }:

{
  # ----- User Packages ----- #
  home.packages = with pkgs; [

    # ---- Terminal & Shell ---- #
    kitty
    fastfetch
    yazi
    btop
    amdgpu_top
    tmux
    fzf
    lazygit
    commitizen
    zsh-powerlevel10k
    fzf-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    oh-my-zsh
    astroterm
    imagemagick

    # ---- Development ---- #
    vscodium
    godot
    opencode
    # Python Environment
    (python3.withPackages(p: with p; [
      numpy
      requests
      pandas
    ]))

    # ---- GUI Applications ---- #
    brave
    qutebrowser
    vesktop
    signal-desktop
    localsend
    nextcloud-client
    zotero
    calibre
    gnome-boxes
    element-desktop

    # ---- Media & Creative ---- #
    mpv
    playerctl
    pamixer
    kdePackages.kdenlive
    shotcut
    krita
    cava
    yt-dlp
    ffmpeg
    lrcget
    hyprshot
    
    # ---- Gaming ---- #
    heroic
    lutris
    legendary-gl
    wine
    winetricks
    prismlauncher
    osu-lazer-bin

    # ---- Music (MPD Related) ---- #
    rmpc
    mpc

    # ---- Theming & Desktop UI ---- #
    rofi
    wofi
    nwg-look
    dysk
    pastel
    darkman
    base16-schemes
    tokyonight-gtk-theme
    grimblast
    catppuccin-gtk
    
    # ---- Flake Inputs / Custom ---- #
    inputs.nixos-unstable.legacyPackages.${pkgs.system}.quickshell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
