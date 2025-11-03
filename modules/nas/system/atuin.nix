{ config, ... }:

{

  services = {
    atuin = {
      enable = true;
      maxHistoryLength = 1000000;
      openRegistration = true;
      database = {
        uri = null;
        createLocally = false;
      };

      port = 8991;
    };
    nginx.virtualHosts = {
      "atuin.${config.nas.baseDomain.public}" = {
        forceSSL = true;
        sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
        sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString config.services.atuin.port}";
        };
      };
    };
  };

  systemd.services.atuin.serviceConfig.EnvironmentFile = config.age.secrets."atuin.env".path;

}
