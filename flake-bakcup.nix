{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";  # IMPORTANT: keeps versions in sync
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };

  outputs = { self, nixpkgs, nix-flatpak, home-manager, nixvim, catppuccin, hyprland, hyprgrass, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        home-manager.nixosModules.default
        {
          home-manager.users.anklus = {
            imports = [
              nixvim.homeManagerModules.nixvim
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

      # (You can define more dev shells here later, e.g. pythonDev)
    };
  };
}

