{
  pkgs,
  config,
  lib,
  ...
}:

let
  postgresqlDataDir = "/nvmeStorage/db/postgres";
  qdrantDataDir = "/nvmeStorage/db/qdrant";
  qdrantSnapshotDir = "/nvmeStorage/db/qdrant_snapshots";
in
{
  services = {
    postgresql = {
      enable = true;
      dataDir = postgresqlDataDir;
      enableTCPIP = true;
      authentication = "host all all 10.0.0.1/8 md5";
      package = pkgs.postgresql_15;
      extensions =
        ps: with ps; [
          pgvectorscale
          pgvector
        ];
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
    qdrant = {
      enable = true;
      settings = {
        storage = {
          storage_path = qdrantDataDir;
          snapshots_path = qdrantSnapshotDir;
        };
        service = {
          host = "0.0.0.0";
          http_port = "6333";
          grpc_port = "6334";
        };
        telemetry_disabled = true;
      };
    };
  };

  systemd.services.qdrant.serviceConfig = {
    DynamicUser = lib.mkForce false;
  };

  networking.firewall.allowedTCPPorts = [
    5432
    6333
    6334
  ];

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
    "10-qdrantData" = {
      "${qdrantDataDir}" = {
        d = {
          mode = "0777";
        };
      };
    };
    "10-qdrantSnapshot" = {
      "${qdrantSnapshotDir}" = {
        d = {
          mode = "0777";
        };
      };
    };
  };

}
