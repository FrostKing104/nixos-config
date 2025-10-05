# webApps.nix
# This file defines all of your browser-based web applications.

{ pkgs, ... }:

{
  home.packages = [
    pkgs.chromium
    pkgs.papirus-icon-theme
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
      # Fixed: Properly escape the URL with double quotes and escape internal quotes
      exec = "${pkgs.chromium}/bin/chromium --app=\"https://ticktick.com/webapp/#q/today/tasks/\"";
      icon = "ticktick";
      comment = "TickTick To-Do List and Task Manager";
      terminal = false;
      type = "Application";
      # Fixed: Use only one main category to avoid menu duplication
      categories = [ "Office" ];
    };
    # -- Obsidian Vaults -- #
    "obsidian-main" = {
      name = "Obsidian Main Vault";
      comment = "Open the main Obsidian vault";
      exec = "obsidian-fixed obsidian://vault/45be03fe07ce1733";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };

    "obsidian-college" = {
      name = "Obsidian College Vault";
      comment = "Open the college Obsidian vault";
      exec = "obsidian-fixed obsidian://vault/bb1b079b93a59a4e";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };

    "obsidian-writing" = {
      name = "Obsidian Writing Vault";
      comment = "Open the writing Obsidian vault";
      exec = "obsidian-fixed obsidian://vault/5088080f897a87ad";
      icon = "obsidian";
      type = "Application";
      categories = [ "Office" "Utility" ];
    };
  };
}
