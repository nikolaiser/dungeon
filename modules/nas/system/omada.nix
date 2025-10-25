{
  pkgs,
  config,
  pkgs-omada,
  ...
}:

let
  omadaUrl = "omada.${config.nas.baseDomain.private}";
in
{

  services.omada = {
    enable = true;
    package = pkgs-omada.omada-software-controller;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    ${omadaUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "https://127.0.0.1:8043";
      };
    };
  };
}
