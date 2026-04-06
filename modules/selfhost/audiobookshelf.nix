{
  dungeon.selfhost.nixos =
    { config, pkgs, ... }:

    let
      audiobookshelfDomain = "audiobookshelf.${config.nas.baseDomain.public}";
    in
    {

      services = {
        audiobookshelf = {
          enable = true;
          user = "media";
          group = "media";
        };

        nginx.virtualHosts."${audiobookshelfDomain}" = {
          forceSSL = true;
          sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
          sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
          locations."/" = {
            proxyPass = "http://${builtins.toString config.services.audiobookshelf.host}:${builtins.toString config.services.audiobookshelf.port}";
            proxyWebsockets = true;
          };
        };
      };

    };

}
