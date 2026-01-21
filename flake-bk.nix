{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Version 24.11 for rocm that it supported on my Polaris AMD card
    nixpkgs-rocm5.url = "github:nixos/nixpkgs/nixos-23.11";
    
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    
    catppuccin.url = "github:catppuccin/nix";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixos-unstable"; 
    };

    # aagl - Anime Game Launcher
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-rocm5, nixos-unstable, nix-flatpak, home-manager, nixvim, catppuccin, aagl, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        home-manager.nixosModules.default
        inputs.noctalia.nixosModules.default
        aagl.nixosModules.default
        {
          home-manager.users.anklus = {
            imports = [
              nixvim.homeModules.nixvim
              ./home-manager/home.nix
            ];
          };
        }
      ];
    };

    # Development shells
    devShells.${system} = {
      # ---- OpenCode Shell ----
      opencode = pkgs.mkShell {
        name = "opencode-shell";
        packages = with pkgs; [
          nodejs_22
          bun
          go
          python3
          git
        ];

        shellHook = ''
          echo "🚀 Welcome to the OpenCode dev shell!"
          echo "Run:  cd dev/opencode && bun run dev"
        '';
      };
    };
  };
}

