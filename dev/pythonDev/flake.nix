{
  description = "Python Development Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    { 

      devShells."x86_64-linux".default = pkgs.mkShell {

        packages = [ 
          (pkgs.python3.withPackages(p: with p; [
            numpy
            requests
            pandas
          ]))
        ];

        shellHook = ''
          echo "Welcome to the Python shell! We hope you enjoy your stay :D"
        '';
      };
    };
}
