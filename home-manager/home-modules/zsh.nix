{ config, pkgs, lib, ... }:
{
  # --- ZSH Configuration! --- #
  programs.zsh = {
    enable = true;
    # Aliases
    shellAliases = {
      # Editing Configs
      config = "nvim ~/nixos-config/configuration.nix";
      packages = "nvim ~/nixos-config/packages.nix";
      hm = "nvim ~/nixos-config/home-manager/home.nix";
      hmpackages = "nvim ~/nixos-config/home-manager/home-modules/packages.nix";
      # Rebuilding
      testflake = "rm -f /home/anklus/.config/fcitx5/profile.backup & sudo nixos-rebuild test --flake ~/nixos-config";
      switchflake = "rm -f /home/anklus/.config/fcitx5/profile.backup & sudo nixos-rebuild switch --flake ~/nixos-config";
      # Shells
      dev = "nix develop ~/shells";
      # Scripts
      fixtray = "source ~/nixos-config/scripts/fixTray.sh";
      checkshelldiff = "source ~/nixos-config/scripts/checkShellDiff.sh";
      sky = "astroterm -a 33.8 -o -83.9 --color --constellations -u -t 4.5 -s 5 -f 30";
      # Custom aliases
      cc = "wl-copy";
      pp = "wl-paste";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];  # Just include git here as we'll handle others manually
    };

    # Combined init content with powerlevel10k loading first
    initContent = ''
      # Load powerlevel10k theme first and source the configuration file
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # Set up FZF base explicitly
      export FZF_BASE="${pkgs.fzf}/share/fzf"

      # --- Catppuccin Mocha Theme + Preview Script for FZF ---
      export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi \
        --preview '~/.config/fzf/fzf-preview.sh {}'"

      # Source ZSH plugins properly
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      # --- Custom FZF Keybinds ---
      # CTRL-F for file search (replaces CTRL-T)
      bindkey '^f' fzf-file-widget

      # Add key bindings for history-substring-search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Fastfetch on Startup
      fastfetch --config ~/.config/fastfetch/ascii-only.jsonc
      fastfetch --config ~/.config/fastfetch/config.jsonc

      # Custom function for fzf + nvim (Now uses the global preview script)
      fzfnvim() {
        local file
        file=$(fzf --query="$1" --select-1 --exit-0)
        [ -n "$file" ] && nvim "$file"
      }
    '';
  };
}
