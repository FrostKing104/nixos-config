{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };

  outputs = { self, nixpkgs, nix-flatpak, home-manager, nixvim, catppuccin, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        # REMOVED: catppuccin.homeModules.catppuccin (this belongs in Home Manager config)
        home-manager.nixosModules.default
        {
          home-manager.users.anklus = {
            imports = [
              nixvim.homeManagerModules.nixvim
              ./home-manager/home.nix  # Import your home.nix file here
            ];
          };
        }
      ];
    };
  };
}
