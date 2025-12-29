{
  config,
  pkgs,
  pkgs-master,
  ...
}:

let
  readeckUrl = "readeck.${config.nas.baseDomain.public}";
in
{
  services = {
    readeck = {
      enable = true;
      settings = {
        server.port = 9111;
      };
      environmentFile = config.age.secrets."readeck.env".path;
    };

    nginx.virtualHosts = {
      ${readeckUrl} = {
        forceSSL = true;
        sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
        sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.readeck.settings.server.port}";
          proxyWebsockets = true;
        };
      };
    };
  };

}
