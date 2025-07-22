{ pkgs, config, ... }:

let
  ntfyUrl = "ntfy.${config.nas.baseDomain.private}";
in
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${ntfyUrl}";
      listen-http = "127.0.0.1:2586";
    };
  };
  services.nginx.virtualHosts = {
    ${ntfyUrl} = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      };
    };
  };

  systemd.tmpfiles.settings."10-ntfy"."/var/lib/ntfy-sh".d = {
    user = config.services.ntfy-sh.user;
    group = config.services.ntfy-sh.group;
    mode = "0777";
  };
}
