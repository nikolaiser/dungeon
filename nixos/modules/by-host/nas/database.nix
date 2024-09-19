{ pkgs, config, ... }:

let
  postgresqlDataDir = "/nvmeStorage/db/postgres";
in
{
  services.postgresql = {
    enable = true;
    dataDir = postgresqlDataDir;
    enableTCPIP = true;
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];

  systemd.tmpfiles.settings = {
    "10-postgresql" = {
      "${postgresqlDataDir}" = {
        d = {
          user = config.systemd.services.postgresql.serviceConfig.User;
          group = config.systemd.services.postgresql.serviceConfig.Group;
          mode = "0770";
        };
      };
    };
  };

}
