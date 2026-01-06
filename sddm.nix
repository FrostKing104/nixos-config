{ pkgs, config, lib, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    package = lib.mkForce pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];
  };

  # Astronaut theme looks here for its configuration
  environment.etc."sddm-astronaut-theme.conf".text = lib.mkForce ''
    [General]
    HeaderText=ようこそ!
    Background=${./loginScreenBackground.png}
    FullBlur=false
    Theme=astronaut
    Font="Noto Sans"

    [Colors]
    HeaderTextColor=#ffffff
    BackgroundColor=#fde086
    DimBackgroundColor=#fde086
    LoginFieldBackgroundColor=#fde086
    PasswordFieldBackgroundColor=#fde086
    HighlightBackgroundColor=#fde086
  '';

  environment.systemPackages = with pkgs; [
    sddm-astronaut
    # Ensure the libraries are available to the system-wide QML path
    kdePackages.qtmultimedia 
  ];
}
