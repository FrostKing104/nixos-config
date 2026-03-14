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
      tabstop = 2;
      expandtab = true;
      termguicolors = true;
      conceallevel = 2;
      autoread = true;
    };

    plugins.web-devicons.enable = true;

    plugins.nvim-tree = {
      enable = true;
    };

    plugins.indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
        };
        scope = {
          enabled = false; # mini.indentscope handles the animated scope line
        };
      };
    };

    plugins.obsidian = {
      enable = true;
      settings = {
        completion = {
          nvim_cmp = true;
          min_chars = 2;
        };
        workspaces = [
          {
            name = "Main Vault";
            path = "~/Documents/Obsidian Vaults/Main Vault";
          }
        ];
      };
    };

    plugins.render-markdown = {
      enable = true;
      settings = {
        file_types = [ "markdown" "Avante" ];
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = ":NvimTreeToggle<CR>";
        options.desc = "Toggle NvimTree";
      }
      {
        mode = [ "n" "i" "v" ];
        key = "<A-z>";
        action = "<cmd>undo<CR>";
        options.desc = "Undo (Alt+Z)";
      }
      {
        mode = [ "n" "v" ];
        key = "<C-a>";
        action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<CR>";
        options.desc = "Ask OpenCode";
      }
      {
        mode = [ "n" "v" ];
        key = "<C-x>";
        action = "<cmd>lua require('opencode').select()<CR>";
        options.desc = "OpenCode Menu";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-.>";
        action = "<cmd>lua require('opencode').toggle()<CR>";
        options.desc = "Toggle OpenCode";
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
      nvim-numbertoggle
      nvim-tree-lua
      harpoon2
      mini-nvim  # <-- add this

      (pkgs.vimUtils.buildVimPlugin {
        name = "opencode-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "nickjvandyke";
          repo = "opencode.nvim";
          rev = "main";
          hash = "sha256-N80LTAsWds4cmnHJkn18boo+zcBRj3jNPHABOyczoBM=";
        };
      })
    ];

    globals.mapleader = " ";

    extraConfigLua = ''
      vim.g.opencode_opts = {
        auto_reload = true,
        server = {}
      }

      require('nvim-tree').setup({})

      -- mini.indentscope: animated scope line for current block
      require('mini.indentscope').setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          delay = 0,
          animation = require('mini.indentscope').gen_animation.quadratic({
            easing = 'out',
            duration = 60,
            unit = 'total',
          }),
        },
      })

      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Live Grep' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find Buffers' })

      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
        ui = {
          border = "rounded",
          width = vim.api.nvim_win_get_width(0) - 20,
          height = vim.api.nvim_win_get_height(0) - 10,
        }
      })

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
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
        no_bold = false;

        custom_highlights = {
          "@markup.strong" = { bold = true; };
          "RenderMarkdownBold" = { bold = true; };
          "RenderMarkdownH1Bg" = { bold = true; };
          "MiniIndentscopeSymbol" = { fg = "#cba6f7"; };
          "IblIndent" = { fg = "#45475a"; };
        };

        integrations = {
          treesitter = true;
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
            };
          };
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [ "markdown" "markdown_inline" ];
      };
    };

    plugins.gitsigns = {
      enable = true;
    };

  } // lspConfig;
}
