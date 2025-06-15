{ config, lib, ... }:

let
  immichUrl = "immich.${config.nas.baseDomain.private}";
  immichMlDir = "/nvmeStorage/immich-ml";
  immichMediaDir = "/immich";
  cfg = config.services.immich;
  IMMICH_HOST = cfg.host;
  IMMICH_PORT = toString cfg.port;
  IMMICH_MEDIA_LOCATION = cfg.mediaLocation;
  IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";

in
{

  services = {
    immich = {
      enable = true;
      database.enable = false;
      mediaLocation = immichMediaDir;
      redis.enable = true;
      machine-learning.environment.MACHINE_LEARNING_CACHE_FOLDER = lib.mkForce immichMlDir;
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
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
          '';
        };
      };
    };
  };

  systemd.tmpfiles.settings = {
    "10-immichData" = {
      "${immichMlDir}" = {
        d = {
          user = config.services.immich.user;
          group = config.services.immich.group;
          mode = "0750";
        };
      };
    };
    "10-immichMedia" = {
      "${immichMediaDir}" = {
        d = {
          user = config.services.immich.user;
          group = config.services.immich.group;
          mode = "0750";
        };
      };
    };
  };
}
