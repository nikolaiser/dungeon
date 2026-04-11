{
  dungeon.selfhost.nixos =
    { pkgs, config, ... }:

    let
      plankaUrl = "planka.${config.nas.baseDomain.private}";
      plankaDataDir = "/var/lib/planka";
      dataDir = "${plankaDataDir}/data";
    in
    {

      virtualisation.oci-containers.containers."planka" = {
        image = "ghcr.io/plankanban/planka:latest";
        autoStart = true;
        environment = {
          BASE_URL = "https://${plankaUrl}";
          LOG_LEVEL = "debug";
        };
        environmentFiles = [ config.age.secrets."planka.env".path ];
        volumes = [
          "${dataDir}:/app/data"
        ];
        ports = [
          "3200:1337/tcp"
        ];
      };
      services.nginx.virtualHosts = {
        ${plankaUrl} = {
          forceSSL = true;
          useACMEHost = "${config.nas.baseDomain.private}";
          locations."/" = {
            proxyWebsockets = true;
            proxyPass = "http://127.0.0.1:3200";
          };
        };
      };

      systemd.tmpfiles.settings = {
        "10-plankaData" = {
          "${plankaDataDir}" = {
            d = {
              mode = "0750";
            };
          };
        };
        "10-plankaDataDir" = {
          "${dataDir}" = {
            d = {
              mode = "0750";
            };
          };
        };
      };
    };
}
