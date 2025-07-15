{ pkgs, config, ... }:

let
  mealieUrl = "mealie.${config.nas.baseDomain.private}";
in
{
  services.mealie = {
    enable = true;
    credentialsFile = config.age.secrets."mealie.env".path;
  };
  services.nginx.virtualHosts = {
    ${mealieUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString config.services.mealie.port}";
      };
    };
  };
}
