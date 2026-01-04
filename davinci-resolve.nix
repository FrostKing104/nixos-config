{ pkgs, inputs, ... }:

let
  # Import the old nixpkgs specifically for the ROCm 5 driver
  legacyPkgs = import inputs.nixpkgs-rocm5 {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  # --- Hardware & Drivers ---
  hardware.graphics = {
    enable = true;
    extraPackages = [
      legacyPkgs.rocmPackages_5.clr.icd 
    ];
  };

  # --- Environment Variables ---
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";          # Required for Polaris (RX 580)
    QT_QPA_PLATFORM = "xcb";            # Stabilizes Resolve UI on Hyprland
    HSA_OVERRIDE_GFX_VERSION = "9.0.0"; # Necessary for AI/Ollama support
  };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    davinci-resolve
    clinfo
  ];
}
