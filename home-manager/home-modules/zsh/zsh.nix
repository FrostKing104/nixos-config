{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      config = "nvim ~/nixos-config/configuration.nix";
      packages = "nvim ~/nixos-config/packages.nix";
      hm = "nvim ~/nixos-config/home-manager/home.nix";
      hmpackages = "nvim ~/nixos-config/home-manager/home-modules/packages.nix";
      testflake = "rm -f /home/anklus/.config/fcitx5/profile.backup & sudo nixos-rebuild test --flake ~/nixos-config";
      switchflake = "rm -f /home/anklus/.config/fcitx5/profile.backup & sudo nixos-rebuild switch --flake ~/nixos-config";
      dev = "nix develop ~/shells";
      fixtray = "source ~/nixos-config/scripts/fixTray.sh";
      checkshelldiff = "source ~/nixos-config/scripts/checkShellDiff.sh";
      sky = "astroterm -a 33.8 -o -83.9 --color --constellations -u -t 4.5 -s 5 -f 30";
      cc = "wl-copy";
      pp = "wl-paste";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    initContent = ''
      # 1. Load powerlevel10k theme first
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # 2. Set up FZF base
      export FZF_BASE="${pkgs.fzf}/share/fzf"

      # 3. Source ZSH plugins (Dynamic Nix Paths)
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      # 4. Load external custom config
      ${builtins.readFile ./zshrc}
    '';
  };
}
