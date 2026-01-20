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
    gh
    lazygit
    commitizen
    zsh-powerlevel10k
    fzf-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    oh-my-zsh
    astroterm

    # ---- Development ---- #
    vscodium
    godot
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
    
    # ---- Flake Inputs / Custom ---- #
    inputs.nixos-unstable.legacyPackages.${pkgs.system}.quickshell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
