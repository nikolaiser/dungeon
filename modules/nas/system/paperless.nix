{
  config,
  pkgs,
  pkgs-master,
  ...
}:

let
  paperlessUrl = "paperless.${config.nas.baseDomain.private}";
  paperlessDataDir = "/nvmeStorage/paperless";
  paperlessMediaDir = "/paperless";
in
{
  services = {
    paperless = {
      enable = true;
      package = pkgs-master.paperless-ngx;
      dataDir = paperlessDataDir;
      mediaDir = paperlessMediaDir;
      port = 28981;
      settings = {
        PAPERLESS_URL = "https://${paperlessUrl}";
        PAPERLESS_OCR_LANGUAGE = "eng+deu+rus";
        PAPERLESS_TIME_ZONE = "Europe/Berlin";
      };
    };

    nginx.virtualHosts = {
      ${paperlessUrl} = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 1000M;
          '';
        };
      };
    };
  };

  systemd.tmpfiles.settings = {
    "10-paperlessData" = {
      "${paperlessDataDir}" = {
        d = {
          user = config.services.paperless.user;
          group = config.services.paperless.user;
          mode = "0750";
        };
      };
    };
    "10-paperlessMedia" = {
      "${paperlessMediaDir}" = {
        d = {
          user = config.services.paperless.user;
          group = config.services.paperless.user;
          mode = "0750";
        };
      };
    };
  };
}
