{ config, pkgs-stable, ... }:

let
  seafileUrl = "seafile.${config.nas.baseDomain.public}";
in
{
  services = {
    seafile = {
      seahubPackage = pkgs-stable.seahub;
      enable = true;
      adminEmail = "mail@nikolaiser.com";
      dataDir = "/seafile";
      ccnetSettings.General.SERVICE_URL = "https://${seafileUrl}";
    };

    nginx.virtualHosts = {
      ${seafileUrl} = {
        forceSSL = true;
        sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
        sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
        locations = {
          "/" = {
            proxyPass = "http://unix:/run/seahub/gunicorn.sock";
            proxyWebsockets = true;
          };
          "/seafhttp" = {
            proxyPass = "http://127.0.0.1:${builtins.toString config.services.seafile.seafileSettings.fileserver.port}";
            extraConfig = ''
              rewrite ^/seafhttp(.*)$ $1 break;
              client_max_body_size 0;
              proxy_connect_timeout  36000s;
              proxy_read_timeout  36000s;
              proxy_send_timeout  36000s;
              send_timeout  36000s;
              proxy_http_version 1.1;
            '';
          };
        };

      };
    };
  };

  systemd.tmpfiles.settings."10-seafile"."/seafile".d = {
    user = config.services.seafile.user;
    group = config.services.seafile.group;
    mode = "0777";
  };

}
