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
      conceallevel = 2; # Required for render-markdown to hide markdown syntax
      autoread = true;  # Recommended for opencode auto_reload
    };

    plugins.web-devicons.enable = true;

    plugins.nvim-tree = {
      enable = true;
    };
    
    # --- Obsidian & Markdown Setup ---
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
        # Optional: Daily notes configuration
        #daily_notes = {
        #  folder = "dailies";
        #  date_format = "%Y-%m-%d";
        #};
      };
    };

    plugins.render-markdown = {
      enable = true;
      settings = {
        # Can override 
        # colors/icons here if needed.
        file_types = [ "markdown" "Avante" ]; 
      };
    };
    # --------------------------------------

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
      
      # Add OpenCode directly from GitHub
      (pkgs.vimUtils.buildVimPlugin {
        name = "opencode-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "nickjvandyke";
          repo = "opencode.nvim";
          rev = "main"; 
          hash = "sha256-QQVgQaQ877BKykDvrdZO0cyJQna9f5B1/vTfESLLGoE="; 
        };
      })
    ];

    globals.mapleader = " ";

    extraConfigLua = ''
      -- Initialize OpenCode
      vim.g.opencode_opts = {
          auto_reload = true,
	  server = {}
      }

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

      -- Harpoon Setup
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
        -- UI Customization
        ui = {
          border = "rounded", -- This gives you that clean, rounded look
          width = vim.api.nvim_win_get_width(0) - 20, -- Dynamic width with padding
          height = vim.api.nvim_win_get_height(0) - 10,
        }
      }) 

      -- Harpoon Keymaps
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
