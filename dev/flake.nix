{
  description = "Development shells for OpenCode, Python, and combined coding work";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system} = {

      # 🐍 Python Development Shell
      python = pkgs.mkShell {
        name = "python-dev";
        packages = [
          (pkgs.python3.withPackages (p: with p; [
            numpy
            requests
            pandas
          ]))
        ];

        shellHook = ''
          echo "🐍 Welcome to the Python shell!"
          echo "Python packages available: numpy, requests, pandas"
        '';
      };

      # 🚀 OpenCode Development Shell
      opencode = pkgs.mkShell {
        name = "opencode-dev";
        packages = with pkgs; [
          nodejs_22
          bun
          go
          python3
          git
        ];

        shellHook = ''
          echo "🚀 Welcome to the OpenCode dev shell!"
          echo "Run: cd dev/opencode && bun run dev"
        '';
      };

      # 💻 Combined Coding Shell (Python + OpenCode)
      coding = pkgs.mkShell {
        name = "coding-dev";
        packages = with pkgs; [
          nodejs_22
          bun
          go
          git
          (pkgs.python3.withPackages (p: with p; [
            numpy
            requests
            pandas
          ]))
        ];

        shellHook = ''
          echo "💻 Welcome to the coding shell!"
          echo "Includes both Python and OpenCode tools."
        '';
      };
    };
  };
}

