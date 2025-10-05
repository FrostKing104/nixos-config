# ~/nixos-config/home-manager/gog.nix

{ config, pkgs, ... }:

{
  # This file manages the gogdl command-line tool.
  # --- Install gogdl --- #
  home.packages = [
    pkgs.gogdl
  ];

  # --- Configure gogdl Authentication --- #
  # This ensures the directory for gogdl's auth file exists.
  # You will still need to run the `gogdl auth` command ONE TIME manually
  xdg.configDir."gogdl".enable = true;


  # -- METHOD 2: Fully Declarative Secrets (Advanced) --
  # UNCOMMENT the block below if you have sops-nix configured and want
  # to manage your auth token declaratively.
  /*
  sops.secrets.gogdl_auth_json = {
    # This should point to your encrypted secrets file.
    sopsFile = ../../secrets.yaml;
    # This is the destination path for the decrypted file.
    path = "${config.xdg.configHome}/gogdl/auth.json";
  };
  */
}
