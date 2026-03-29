{ pkgs, lib, config, ... }:

let
  # --- 1. Helper for Obsidian ---
  # Re-defining the fixed script so we can reference it in the menu commands
  obsidian-fixed = pkgs.writeShellScriptBin "obsidian-fixed" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.obsidian}/bin/obsidian --ozone-platform=x11 "$@"
  '';

  # --- 2. Your Menu Configuration ---
  myMenu = [
    {
      key = "f";
      desc = "Firefox";
      cmd = "firefox";
    }
    {
      key = "d";
      desc = "Social";
      submenu = [
        { key = "d"; desc = "Discord";   cmd = "vesktop"; }
        { key = "s"; desc = "Signal";    cmd = "signal-desktop"; }
        { key = "m"; desc = "Messenger"; cmd = "${pkgs.chromium}/bin/chromium --app=https://messenger.com"; }
      ];
    }
    {
      key = "o";
      desc = "Obsidian";
      submenu = [
        { key = "m"; desc = "Main Vault";    cmd = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/45be03fe07ce1733"; }
        { key = "c"; desc = "College Vault"; cmd = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/bb1b079b93a59a4e"; }
        { key = "w"; desc = "Writing Vault"; cmd = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/5088080f897a87ad"; }      ];
    }
    {
      key = "s";
      desc = "Screenshot";
      submenu = [
        { key = "s"; desc = "Screen";  cmd = "bash -c 'hyprshot -m output --raw | tee >(wl-copy && notify-send \"Screenshot\" \"Copied to clipboard\") | swappy -f -'"; }
        { key = "r"; desc = "Region";  cmd = "bash -c 'hyprshot -m region --raw | tee >(wl-copy && notify-send \"Screenshot\" \"Copied to clipboard\") | swappy -f -'"; }
        { key = "w"; desc = "Window";  cmd = "bash -c 'hyprshot -m window --raw | tee >(wl-copy && notify-send \"Screenshot\" \"Copied to clipboard\") | swappy -f -'"; }      ];
    }
  ];

  # --- 3. Generate the Config File ---
  configFile = pkgs.writeText "wlr-which-key-config.yaml" (lib.generators.toYAML {} {
    font = "JetBrainsMono Nerd Font 12";
    background = "#1e1e2e"; 
    color = "#cdd6f4";      
    border = "#cba6f7";     
    separator = " ➜ ";
    border_width = 3;
    corner_r = 2;
    padding = 15;
    anchor = "center";
    menu = myMenu;
  });

  # --- 4. Create the Executable Script ---
  sysMenuScript = pkgs.writeShellScriptBin "sys-menu" ''
    ${lib.getExe pkgs.wlr-which-key} ${configFile}
  '';

in
{
  home.packages = [ 
    pkgs.wlr-which-key
    sysMenuScript 
    obsidian-fixed
  ];
}
