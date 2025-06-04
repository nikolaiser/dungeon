{ config, ... }:

let
  searxngUrl = "searxng.${config.nas.baseDomain.public}";
in
{
  services = {
    searx = {
      enable = true;
      settings = {
        server = {
          port = 8888;
          bind_address = "127.0.0.1";
          secret_key = "@SEARXNG_SECRET@";
        };
        search = {
          formats = [
            "html"
            "json"
          ];
        };
      };
    };

    nginx.virtualHosts."${searxngUrl}" = {
      forceSSL = true;
      sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
      sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.searx.settings.server.port}";
      };
    };
  };
}
