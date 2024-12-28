{ config, ... }:

{
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      environmentFile = config.age.secrets."vaultwarden.env".path;
    };

    nginx.virtualHosts."bitwarden.${config.baseDomain.public}" = {
      forceSSL = true;
      sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
      sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
  };
}
