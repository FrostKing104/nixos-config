# In your nixvim.nix, try this approach instead:

{ config, pkgs, inputs, ... }:
let
  nixvimLib = inputs.nixvim.lib;
  lspConfig = import ./nixvim-lsp.nix { inherit config pkgs; };
in
{
  programs.nixvim = {
    enable = true;
    
    # Try using extraPlugins instead of the built-in telescope module
    extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
    ];

    globals.mapleader = " ";  # Sets space as leader key
    
    # Configure telescope manually
    extraConfigLua = ''
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.cache/"
          },
        },
      })
      
      -- Set up keymaps
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Live Grep' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find Buffers' })
    '';
    
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
    
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };
    
    # Your other plugins...
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    
    plugins.gitsigns = {
      enable = true;
    };

  } // lspConfig;
}
