_: {
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    openFirewall = true;

    mediaLocation = "/mnt/media/immich";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    settings = {
      server.externalDomain = "https://photos.tenjin-dk.com";
      ffmpeg = {
        accel = "vaapi";
        accelDecode = true;
      };
    };
  };

  users.users.immich.extraGroups = [
    "render"
    "video"
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/media/immich 0700 immich immich -"
  ];
  systemd.services.immich-server.unitConfig.RequiresMountsFor = "/mnt/media/immich";

  services.nginx.virtualHosts."photos.tenjin-dk.com" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
      recommendedProxySettings = true;

      extraConfig = ''
        client_max_body_size 50000M;
        client_body_buffer_size 1024k;
        proxy_request_buffering off;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout 600s;
      '';
    };
  };
}
