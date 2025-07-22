{ pkgs, config, ... }:

let
  ntfyUrl = "ntfy.${config.nas.baseDomain.public}";
in
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${ntfyUrl}";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      auth-default-access = "deny-all";
    };
  };
  services.nginx.virtualHosts = {
    ${ntfyUrl} = {
      forceSSL = true;
      sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
      sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
      locations."/" = {
        proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
        proxyWebsockets = true;
      };
    };
  };

  systemd.tmpfiles.settings."10-ntfy"."/var/lib/ntfy-sh".d = {
    user = config.services.ntfy-sh.user;
    group = config.services.ntfy-sh.group;
    mode = "0777";
  };
}
