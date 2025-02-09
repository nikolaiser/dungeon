{ pkgs, config, ... }:

let
  postgresqlDataDir = "/nvmeStorage/db/postgres";
in
{
  services = {
    postgresql = {
      enable = true;
      dataDir = postgresqlDataDir;
      enableTCPIP = true;
      authentication = "host all all 10.0.0.1/8 md5";
      package = pkgs.postgresql_15;
    };
    postgresqlBackup = {
      enable = true;
      location = "/pgbackup";
      backupAll = true;
      compression = "zstd";
    };
    redis.servers = {
      outline = {
        enable = true;
        port = 6380;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];

  systemd.tmpfiles.settings = {
    "10-postgresql" = {
      "${postgresqlDataDir}" = {
        d = {
          user = config.systemd.services.postgresql.serviceConfig.User;
          group = config.systemd.services.postgresql.serviceConfig.Group;
          mode = "0700";
        };
      };
    };
  };

}
