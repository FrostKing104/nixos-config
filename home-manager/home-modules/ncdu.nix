{ pkgs, ... }:

# NCDU (Storage Management Utility)
{
  home.packages = [ pkgs.ncdu ];

  xdg.configFile."ncdu/config".text = ''
    --color dark
    --exclude-caches
    --exclude .git
    --exclude node_modules
    --exclude /nix/store
  '';
}
