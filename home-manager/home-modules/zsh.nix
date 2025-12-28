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
      # Dev Environments
      coding = "nix develop ~/nixos-config/dev#coding";
      python = "nix develop ~/nixos-config/dev#python";
      opencode = "nix develop ~/nixos-config/dev#opencode";
      # Scripts
      fixtray = "source ~/nixos-config/scripts/fixTray.sh";
      checkshelldiff = "source ~/nixos-config/scripts/checkShellDiff.sh";
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
    
      # Source ZSH plugins properly
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    
      # Add key bindings for history-substring-search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      
      # Fastfetch on Startup
      fastfetch --config ~/.config/fastfetch/ascii-only.jsonc
      fastfetch --config ~/.config/fastfetch/config.jsonc
    '';
  };
}
