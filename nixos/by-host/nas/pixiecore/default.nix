{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  hosts = {
    "88:ae:dd:0d:8b:e1" = inputs.self.nixosConfigurations.sina;
    "88:ae:dd:0f:fe:82" = inputs.self.nixosConfigurations.maria;
    "88:ae:dd:0d:8a:0c" = inputs.self.nixosConfigurations.rose;
  };

  mkPixiecoreConfig =
    mac: host: # json
    ''
      {
          "kernel": "file://${host.config.system.build.kernel}/bzImage",
          "initrd": [ "file://${host.config.system.build.netbootRamdisk}/initrd" ],

          "cmdline": "${
            builtins.concatStringsSep " " (
              builtins.concatLists [
                [
                  "init=${host.config.system.build.toplevel}/init"
                ]
              ]
            )
          }"
      }'';

  hostConfigs = pkgs.writeText "host-configs.json" (
    builtins.toJSON (lib.attrsets.mapAttrs mkPixiecoreConfig hosts)
  );

in
{
  services.pixiecore = {
    enable = true;
    mode = "api";
    apiServer = "http://localhost:8181";
    openFirewall = true;
    port = 8282;
  };

  networking.firewall.allowedTCPPorts = [ 8181 ];
  networking.firewall.allowedUDPPorts = [ 4011 ];

  systemd.services.pixiecore-responder = {
    description = "Pixiecore API mode responder";
    wantedBy = [ "pixiecore.service" ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 10;

      ExecStart = "${lib.exe pkgs.scala-cli} --server=false ${./api.scala} -- -f ${hostConfigs}";

    };
  };
}
