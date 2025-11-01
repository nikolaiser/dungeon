{ config, ... }:

{
  services.uptime-kuma = {
    enable = true;
  };

  services.nginx.virtualHosts."uptime-kuma.${config.nas.baseDomain.private}" = {
    forceSSL = true;
    useACMEHost = "${config.nas.baseDomain.private}";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${config.services.uptime-kuma.settings.PORT}";
    };
  };
}
