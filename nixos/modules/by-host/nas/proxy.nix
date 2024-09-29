{ config, ... }:

{
  services.nginx.virtualHosts = {
    "qidi.${config.baseDomain.private}" = {
      forceSSL = true;
      useACMEHost = "${config.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://10.10.163.207:80";
        proxyWebsockets = true;
      };
    };
  };
}
