{ config, ... }:
{

  services.grafana = {
    enable = true;
    provision = {
      enable = true;
      datasources.settings = {

        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
          }
        ];

      };
    };
  };

  services.nginx.virtualHosts."grafana.${config.nas.baseDomain.private}" = {
    forceSSL = true;
    useACMEHost = "${config.nas.baseDomain.private}";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.grafana.settings.server.http_port}";
    };
  };

}
