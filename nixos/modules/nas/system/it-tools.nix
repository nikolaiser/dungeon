{ config, ... }:

let
  itToolsUrl = "it-tools.${config.nas.baseDomain.private}";
in
{
  virtualisation.oci-containers.containers.it-tools = {
    image = "corentinth/it-tools:latest";
    autoStart = true;
    ports = [ "1337:80" ]; # Using port 1337 internally for the service
  };

  services.nginx.virtualHosts = {
    ${itToolsUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:1337";
        proxyWebsockets = true;
      };
    };
  };
}
