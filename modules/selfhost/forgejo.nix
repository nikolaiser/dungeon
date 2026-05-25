{
  dungeon.selfhost.nixos =
    { config, ... }:

    let
      forgejoUrl = "git.${config.nas.baseDomain.public}";
    in
    {
      services = {
        forgejo = {
          enable = true;
          database.type = "postgres";
          lfs.enable = true;
          settings = {
            server = {
              DOMAIN = forgejoUrl;
              ROOT_URL = "https://${forgejoUrl}/";
              HTTP_ADDR = "127.0.0.1";
              HTTP_PORT = 3030;
              START_SSH_SERVER = true;
              SSH_PORT = 2222;
              SSH_LISTEN_PORT = 2222;
              MINIMUM_KEY_SIZE_CHECK = false;
            };
            service.DISABLE_REGISTRATION = true;
            session.COOKIE_SECURE = true;
          };
        };

        nginx.virtualHosts."${forgejoUrl}" = {
          forceSSL = true;
          sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
          sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.forgejo.settings.server.HTTP_PORT}";
            extraConfig = ''
              client_max_body_size 500M;
            '';
          };
        };
      };

      networking.firewall.allowedTCPPorts = [
        config.services.forgejo.settings.server.SSH_LISTEN_PORT
      ];
    };
}
