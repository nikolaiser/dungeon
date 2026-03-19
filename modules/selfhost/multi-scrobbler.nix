{
  dungeon.selfhost.nixos =
    { config, ... }:

    let
      multiScrobblerUrl = "multi-scrobbler.${config.nas.baseDomain.private}";
      multiScrobblerConfigDir = "/var/lib/multiScrobbler";
    in
    {
      virtualisation.oci-containers.containers = {
        multi-scrobbler = {
          image = "docker.io/foxxmd/multi-scrobbler:latest";
          autoStart = true;
          ports = [ "9078:9078" ];
          environment = {
            TZ = "Europe/Berlin";
            BASE_URL = "https://${multiScrobblerUrl}";
            MB_PRESETS = "default,sensible,native";
            LZE_TRANSFORMS = "musicbrainz";
          };
          environmentFiles = [ config.age.secrets."multiscrobbler.env".path ];
          volumes = [ "${multiScrobblerConfigDir}:/config" ];
        };
      };

      services.nginx.virtualHosts = {
        ${multiScrobblerUrl} = {
          forceSSL = true;
          useACMEHost = "${config.nas.baseDomain.private}";
          locations."/" = {
            proxyPass = "http://127.0.0.1:9078";
            proxyWebsockets = true;
          };
        };
      };

      systemd.tmpfiles.settings = {
        "10-multiScrobblerConfig" = {
          "${multiScrobblerConfigDir}" = {
            d = {
              mode = "0770";
            };
          };
        };
      };

    };
}
