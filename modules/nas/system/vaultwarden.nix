{ config, ... }:

let
  bitwardenDomain = "bitwarden.${config.nas.baseDomain.public}";
in
{
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      environmentFile = config.age.secrets."vaultwarden.env".path;
      configureNginx = true;
      domain = bitwardenDomain;
    };

    nginx.virtualHosts."${bitwardenDomain}" = {
      forceSSL = true;
      sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
      sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
    };
  };
}
