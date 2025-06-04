{ config, ... }:

{
  services.nginx.virtualHosts = {
    "qidi.${config.nas.baseDomain.private}" = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://10.10.163.207:80";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 900M;
        '';
      };
    };
  };
}
