{ config, pkgs, inputs, ... }:
let
  nixvimLib = inputs.nixvim.lib;
  lspConfig = import ./nixvim-lsp.nix { inherit config pkgs; };
in
{
  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    plugins.web-devicons.enable = true;

    plugins.nvim-tree = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = ":NvimTreeToggle<CR>";
        options.desc = "Toggle NvimTree";
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
      nvim-numbertoggle
      # Manually adding the package here as a fallback
      nvim-tree-lua
    ];

    globals.mapleader = " ";

    extraConfigLua = ''
      -- Forced manual initialization
      require('nvim-tree').setup({})

      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
        },
      })
      
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
        transparent_background = true;
      };
    };

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
