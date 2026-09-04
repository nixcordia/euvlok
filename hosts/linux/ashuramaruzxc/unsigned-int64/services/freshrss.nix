_: {
  services.freshrss = {
    enable = true;
    virtualHost = "freshrss.tenjin-dk.com";
    baseUrl = "https://freshrss.tenjin-dk.com";
    webserver = "nginx";
    defaultUser = "admin";
    passwordFile = "/etc/secrets/freshrss"; # should this be in sops?
  };

  services.nginx.virtualHosts."freshrss.tenjin-dk.com" = {
    forceSSL = true;
    enableACME = true;
  };
}
