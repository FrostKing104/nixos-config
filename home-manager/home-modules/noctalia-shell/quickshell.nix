{ pkgs, config, ... }:

{
  xdg.configFile."noctalia/custom/WallpaperPicker.qml".source = ./WallpaperPicker.qml;
}
