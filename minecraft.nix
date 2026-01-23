{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.elemental = {
      enable = true;

      package = pkgs.fabricServers.fabric-1_21_1.override {
        loaderVersion = "0.16.10";
      };

      jvmOpts = "-Xms4G -Xmx6G";

#      "mods" = ./mods;
    };
  };

  # Direct systemd override to allow the server to write to your home folder
#  systemd.services.minecraft-server-elemental.serviceConfig.ProtectHome = false;
}
