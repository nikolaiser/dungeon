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

  opnsenseExporterPort = "9199";
  adguardExporterPort = "9618";
in
{

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      (localExporterConfig "node" (builtins.toString config.services.prometheus.exporters.node.port))
      (localExporterConfig "zfs" (builtins.toString config.services.prometheus.exporters.zfs.port))
      (localExporterConfig "opnsense" opnsenseExporterPort)
      (localExporterConfig "adguard" adguardExporterPort)
      (exporterConfig "10.10.0.1" "opnsense" "node" "9100")
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

  virtualisation.oci-containers.containers = {
    "opnsense-exporter" = {
      image = "ghcr.io/athennamind/opnsense-exporter:latest";
      autoStart = true;
      environmentFiles = [
        config.age.secrets."opnsense-exporter.env".path
      ];
      cmd = [
        "--opnsense.insecure"
        "--opnsense.protocol=http"
        "--opnsense.address=10.10.0.1"
        "--exporter.instance-label=main"
        "--web.listen-address=:${opnsenseExporterPort}"
      ];
      ports = [
        "${opnsenseExporterPort}:${opnsenseExporterPort}/tcp"
      ];
    };
    "adguard-exporter" = {
      image = "ghcr.io/henrywhitaker3/adguard-exporter:latest";
      autoStart = true;
      environmentFiles = [
        config.age.secrets."adguardhome-exporter.env".path
      ];
      ports = [
        "${adguardExporterPort}:${adguardExporterPort}/tcp"
      ];
    };
  };

}
