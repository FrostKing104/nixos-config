# webApps.nix
# This file defines all of your browser-based web applications.

{ pkgs, ... }:

{
  # define the required packages
  home.packages = [
    pkgs.chromium
    pkgs.papirus-icon-theme
  ];

  # Define all your web app desktop entries in this set
  xdg.desktopEntries = {
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
  };
}
