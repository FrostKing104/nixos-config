{ config, pkgs, ... }:

{
  # Note: According to NixOS wiki, home-manager does not have fcitx5 settings
  # This configuration should be applied at the system level in configuration.nix
  # But we can still configure some home-level settings and theme

  # Install fcitx5 packages for user access
  home.packages = with pkgs; [
    fcitx5-configtool    # GUI configuration tool
  ];

  # Tokyo Night theme configuration
  home.file.".config/fcitx5/conf/classicui.conf".text = ''
    # Tokyo Night theme
    Theme=tokyonight
    DarkTheme=tokyonight
    UseDarkTheme=True
    UseAccentColor=True
    PerScreenDPI=True
    ForceWaylandDPI=0
    EnableFractionalScale=True
    Font="Inter 11"
    MenuFont="Inter 11"
    TrayFont="Inter 9"
    PreferTextIcon=False
    ShowLayoutNameInIcon=True
    UseInputMethodLanguageToDisplayText=True
  '';

  # Input method profile for Japanese
  home.file.".config/fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=mozc

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=mozc
    Layout=

    [GroupOrder]
    0=Default
  '';

  # General fcitx5 configuration
  home.file.".config/fcitx5/config".text = ''
    [Hotkey]
    TriggerKeys=
    EnumerateWithTriggerKeys=True
    AltTriggerKeys=
    EnumerateForwardKeys=
    EnumerateBackwardKeys=
    ActivateKeys=
    DeactivateKeys=

    [Hotkey/TriggerKeys]
    0=Super+Shift_R

    [Hotkey/AltTriggerKeys]
    0=

    [Behavior]
    ActiveByDefault=False
    ShareInputState=No
    PreeditEnabledByDefault=True
    ShowInputMethodInformation=True
    showInputMethodInformationWhenFocusIn=False
    CompactInputMethodInformation=True
    ShowFirstInputMethodInformation=True
    DefaultPageSize=5
    OverrideXkbOption=False
    CustomXkbOption=
    EnabledAddons=
    DisabledAddons=
    PreloadInputMethod=True
    AllowInputMethodForPassword=False
    ShowPreeditForPassword=False
    AutoSavePeriod=30
  '';

  # Mozc (Japanese) specific configuration
  home.file.".config/fcitx5/conf/mozc.conf".text = ''
    # Mozc Engine Configuration
    PreeditFormat=Composition
    CandidateLayout=Vertical
    SuggestionSize=3
    
    # Tokyo Night colors for candidate window
    CandidateWindowPosition=0
    UseCursorRectangle=True
  '';

  # Additional addon configurations can be added here
  # For example, if you want to customize other aspects:
  
  # Clipboard addon config (if enabled)
  home.file.".config/fcitx5/conf/clipboard.conf".text = ''
    Number of entries=5
    Trigger Key=
    Paste on selection=False
  '';

  # Punctuation addon config
  home.file.".config/fcitx5/conf/punctuation.conf".text = ''
    HalfWidthPunOnEnglish=True
    Enabled=True
  '';

  # Note for the user about system-level configuration needed
  home.file.".config/fcitx5/README-NIXOS.txt".text = ''
    IMPORTANT: This home-manager configuration only sets up user-level settings.
    
    You MUST also add the following to your system configuration (configuration.nix):
    
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc              # Japanese input method
        fcitx5-gtk               # GTK integration
        fcitx5-tokyonight        # Tokyo Night theme
        fcitx5-configtool        # Configuration tool
      ];
    };
    
    For Wayland users, you may also want to add:
    i18n.inputMethod.fcitx5.waylandFrontend = true;
    
    After adding this to your system config, rebuild with:
    sudo nixos-rebuild switch
    
    Then log out and back in for the input method to work properly.
  '';
}
