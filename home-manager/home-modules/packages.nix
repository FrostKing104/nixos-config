{ config, pkgs, ... }:

{

# --- Packages that should be installed to the user profile --- #

  home.packages = with pkgs; [
    rmpc
    btop
    kitty-themes
    fzf
    krita
    dysk
    base16-schemes
    pastel
    darkman
    tokyonight-gtk-theme
    osu-lazer-bin
    amdgpu_top
    calibre
    qbittorrent
    gnome-boxes
    chromium
    cava
    vscodium
    lutris
    legendary-gl
    rare
    wine
    winetricks
    ncmpcpp
    mpc
    yt-dlp
    ffmpeg
    bluetuith
    stress-ng
    zotero
    prismlauncher
    grimblast
    godot
  ];
}
