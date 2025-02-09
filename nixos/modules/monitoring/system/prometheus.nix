{ config, ... }:
let
  nodeExporterConfig = ip: name: {
    job_name = name;
    static_configs = [
      {
        targets = [
          "${ip}:${builtins.toString config.services.prometheus.exporters.node.port}"
        ];
        labels = {
          host = name;
        };
      }
    ];
  };
in
{

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      (nodeExporterConfig "127.0.0.1" "nas")
    ];
  };

  services.nginx.virtualHosts."prometheus.${config.nas.baseDomain.private}" = {
    forceSSL = true;
    useACMEHost = "${config.nas.baseDomain.private}";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
    };
  };

}
