{ config, ... }:
{
  sops.secrets.freshrss = {
    mode = ""; # Not sure what to set
    owner = config.users.users.freshrss.name;
    group = config.users.users.freshrss.group;
  };
  services.freshrss = {
    enable = true;
    virtualHost = "freshrss.tenjin-dk.com";
    baseUrl = "https://freshrss.tenjin-dk.com";
    webserver = "nginx";
    defaultUser = "admin";
    passwordFile = config.sops.secrets.freshrss.path;
    database = {
      type = "pgsql";
      port = 3306;
    };
  };

  services.nginx.virtualHosts."freshrss.tenjin-dk.com" = {
    forceSSL = true;
    enableACME = true;
  };
}
