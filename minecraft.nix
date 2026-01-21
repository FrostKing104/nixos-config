{ lib, inputs, pkgs, ...}:

{

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      elemental = {
        enable = true;
	dataDir = "home/anklus/minecraftServers";
        
	package = pkgs.fabricServers.fabric-26_1;

        symlinks = {
	  "mods" = ./mods;
	};

	# Strict RAM limit flags - IMPORTANT for performance
	jvmOpts = "-Xms4G -Xmx6G";

      };
    };
  };

}
