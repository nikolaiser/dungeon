{
  config,
  lib,
  pkgs-master,
  ...
}:

let
  immichUrl = "immich.${config.nas.baseDomain.private}";
  immichMlDir = "/nvmeStorage/immich-ml";
  immichHomeDir = "/nvmeStorage/immich/home";
  immichMediaDir = "/immich";
  cfg = config.services.immich;
in
{

  services = {
    immich = {
      enable = true;
      database.enable = false;
      mediaLocation = immichMediaDir;
      redis.enable = true;
      machine-learning.environment = {
        MACHINE_LEARNING_CACHE_FOLDER = lib.mkForce immichMlDir;
      };
      database.user = "postgres";
      environment = lib.mkForce {
        REDIS_SOCKET = cfg.redis.host;
        REDIS_PORT = toString cfg.redis.port;
        REDIS_HOSTNAME = cfg.redis.host;
        IMMICH_HOST = cfg.host;
        IMMICH_PORT = toString cfg.port;
        IMMICH_MEDIA_LOCATION = cfg.mediaLocation;
        IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
      };
    };

    nginx.virtualHosts = {
      ${immichUrl} = {
        forceSSL = true;
        useACMEHost = "${config.nas.baseDomain.private}";
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.immich.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
          '';
        };
      };
    };
  };

  users.users.${cfg.user}.home = immichHomeDir;

  systemd.tmpfiles.settings = {
    "10-immichData" = {
      "${immichMlDir}" = {
        d = {
          user = config.services.immich.user;
          group = config.services.immich.group;
          mode = "0770";
        };
      };
    };
    "10-immichHome" = {
      "${immichHomeDir}" = {
        d = {
          user = config.services.immich.user;
          group = config.services.immich.group;
          mode = "0770";
        };
      };
    };
    "10-immichMedia" = {
      "${immichMediaDir}" = {
        d = {
          user = config.services.immich.user;
          group = config.services.immich.group;
          mode = "0777";
        };
      };
    };
  };
}
