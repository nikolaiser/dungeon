{ config, ... }:
let
  exporterConfig = ip: node: name: port: {
    job_name = "${name}-${node}";
    static_configs = [
      {
        targets = [
          "${ip}:${port}"
        ];
        labels = {
          host = node;
        };
      }
    ];
  };

  localExporterConfig = exporterConfig "127.0.0.1" "nas";
in
{

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      (localExporterConfig "node" (builtins.toString config.services.prometheus.exporters.node.port))
      (localExporterConfig "zfs" (builtins.toString config.services.prometheus.exporters.zfs.port))
    ];
    exporters = {
      zfs.enable = true;
    };
  };

  services.nginx.virtualHosts."prometheus.${config.nas.baseDomain.private}" = {
    forceSSL = true;
    useACMEHost = "${config.nas.baseDomain.private}";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
    };
  };

}
