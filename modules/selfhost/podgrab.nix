{
  dungeon.selfhost.nixos =
    { config, pkgs, ... }:

    let
      podgrabDomain = "podgrab.${config.nas.baseDomain.private}";
    in
    {

      services = {
        podgrab = {
          enable = true;
          user = "media";
          group = "media";
          port = 8381;
        };

        nginx.virtualHosts."${podgrabDomain}" = {
          forceSSL = true;
          useACMEHost = "${config.nas.baseDomain.private}";
          locations."/" = {
            proxyPass = "http://127.0.0.1:${builtins.toString config.services.podgrab.port}";
          };
        };
      };

    };

}
