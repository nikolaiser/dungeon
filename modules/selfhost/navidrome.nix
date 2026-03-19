{
  dungeon.selfhost.nixos =
    { config, pkgs, ... }:

    let
      navidromeDomain = "navidrome.${config.nas.baseDomain.public}";
      navidromeDataDir = "/var/lib/navidrome/data";
      navidromeMusicDir = "/var/lib/navidrome/music";
    in
    {

      environment.systemPackages = with pkgs; [
        beets
      ];

      services = {
        navidrome = {
          enable = true;
          user = "media";
          group = "media";
          settings = {
            MusicFolder = navidromeMusicDir;
            DataFolder = navidromeDataDir;
            ListenBrainz.BaseURL = "https://multi-scrobbler.${config.nas.baseDomain.private}/1/";
          };
        };

        nginx.virtualHosts."${navidromeDomain}" = {
          forceSSL = true;
          sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
          sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
          locations."/" = {
            proxyPass = "http://${builtins.toString config.services.navidrome.settings.Address}:${builtins.toString config.services.navidrome.settings.Port}";
          };
        };
      };

      systemd.tmpfiles.settings = {
        "10-navidromeData" = {
          "${navidromeDataDir}" = {
            d = {
              user = config.services.navidrome.user;
              group = config.services.navidrome.group;
              mode = "0770";
            };
          };
        };
        "10-navidromeMusic" = {
          "${navidromeMusicDir}" = {
            d = {
              user = config.services.navidrome.user;
              group = config.services.navidrome.group;
              mode = "0770";
            };
          };
        };
      };
    };

}
