# ~/nixos-config/home-manager/home-modules/desktopShortcuts.nix
{ pkgs, ... }:

let
  # Define the script here, inside the Home Manager module
  obsidian-fixed = pkgs.writeShellScriptBin "obsidian-fixed" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.obsidian}/bin/obsidian --ozone-platform=x11 "$@"
  '';
in
{
  home.packages = [
    pkgs.chromium
    pkgs.papirus-icon-theme
    obsidian-fixed # Add the script to your user's packages
    pkgs.obsidian  # Ensure the main obsidian package is installed for the user
  ];

  # --- Desktop Entries --- #
  xdg.desktopEntries = {
    # -- WebApps -- #
    "youtube-music" = {
      name = "YouTube Music";
      exec = "${pkgs.chromium}/bin/chromium --app=https://music.youtube.com";
      icon = "youtube-music";
      comment = "YouTube Music streaming service";
      terminal = false;
      type = "Application";
      categories = [ "AudioVideo" "Audio" "Network" ];
    };
    "facebook-messenger" = {
      name = "Messenger";
      exec = "${pkgs.chromium}/bin/chromium --app=https://messenger.com";
      icon = "facebook-messenger";
      comment = "Facebook Messenger E2EE messaging service";
      terminal = false;
      type = "Application";
      categories = [ "Network" "InstantMessaging" ];
    };
    "ticktick" = {
      name = "TickTick";
      exec = "${pkgs.chromium}/bin/chromium --app=\"https://ticktick.com/webapp/#q/today/tasks/\"";
      icon = "ticktick";
      comment = "TickTick To-Do List and Task Manager";
      terminal = false;
      type = "Application";
      categories = [ "Office" ];
    };

    # -- Obsidian Vaults -- #
    "obsidian-main" = {
      name = "Obsidian Main Vault";
      comment = "Open the main Obsidian vault";
      exec = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/b179f57fa349d87e";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };

    "obsidian-college" = {
      name = "Obsidian College Vault";
      comment = "Open the college Obsidian vault";
      exec = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/418c20a1afb6550e";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };

    "obsidian-writing" = {
      name = "Obsidian Writing Vault";
      comment = "Open the writing Obsidian vault";
      exec = "${obsidian-fixed}/bin/obsidian-fixed obsidian://vault/1e021ee8aa305e13";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };
  };
}
