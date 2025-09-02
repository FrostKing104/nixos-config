{ config, pkgs, ... }:

{

# --- Packages that should be installed to the user profile --- #

  home.packages = with pkgs; [
    neovim
    # Treesitter parsers
    vimPlugins.nvim-treesitter-parsers.lua
    vimPlugins.nvim-treesitter-parsers.vim
    vimPlugins.nvim-treesitter-parsers.vimdoc
    vimPlugins.nvim-treesitter-parsers.python
    vimPlugins.nvim-treesitter-parsers.javascript
    vimPlugins.nvim-treesitter-parsers.typescript
    vimPlugins.nvim-treesitter-parsers.bash
    vimPlugins.nvim-treesitter-parsers.nix
    vimPlugins.nvim-treesitter-parsers.json
    vimPlugins.nvim-treesitter-parsers.yaml
    # Packages needed for Kickstart script 
    gnumake
    unzip
    libgccjit
    ripgrep
    fd
  ];
}
