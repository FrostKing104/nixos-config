{ config, pkgs, ... }:
{
  # Create an admin password file in /etc
  environment.etc."nextcloud-admin-pass".text = "PMA1";

  services = {
    nginx.enable = true;

    nginx.virtualHosts."100.98.223.8" = {
      # HTTP only; traffic is encrypted by Tailscale
      forceSSL = false;
      enableACME = false;
      # Let the Nextcloud module hook nginx config automatically
      # so no extra root or locations needed here
    };

    nextcloud = {
      enable = true;
      hostName = "100.98.223.8";  # your Tailscale IP
      package = pkgs.nextcloud31;
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "16G";
      https = false;              # important: no TLS here
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit calendar contacts mail notes tasks;
        # leave onlyoffice out until we care about it
      };
      config = {
        dbtype = "pgsql";
        adminuser = "anklus";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
      settings = {
        trusted_domains = [ "100.98.223.8" ];
        overwriteprotocol = "http";
      };
    };

    # Disable OnlyOffice for now to keep things simple
    onlyoffice.enable = false;
  };
}

