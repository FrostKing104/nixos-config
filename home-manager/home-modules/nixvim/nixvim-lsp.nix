{ config, pkgs, ... }:

{
  plugins.lsp = {
    enable = true;
    servers = {
      # Python
      pyright = {
        enable = true;
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic";
              autoImportCompletions = true;
            };
          };
        };
      };
      
      # Bash
      bashls = {
        enable = true;
      };
      
      # Nix
      nil_ls = {
        enable = true;
        settings = {
          formatting = {
            command = [ "nixpkgs-fmt" ];
	  nix.flake.autoArchive = true;
          };
        };
      };
      
      # JSON
      jsonls = {
        enable = true;
      };
      
      # YAML
      yamlls = {
        enable = true;
      };
      
      # Lua (for nvim config)
      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            diagnostics = {
              globals = [ "vim" ];
            };
            workspace = {
              library = [
                "\${3rd}/luv/library"
                "\${3rd}/busted/library"
              ];
            };
          };
        };
      };
    };
  };

  plugins.cmp = {
    enable = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "buffer"; }
        { name = "path"; }
      ];
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-e>" = "cmp.mapping.close()";
        "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      };
    };
  };
}
