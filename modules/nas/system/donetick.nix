{ pkgs, config, ... }:

let
  donetickUrl = "donetick.${config.nas.baseDomain.public}";
in
{

  virtualisation.oci-containers.containers."donetick" = {
    image = "donetick/donetick:latest";
    autoStart = true;
    environment = {
      "DT_ENV" = "selfhosted";
    };
    volumes = [
      "/var/lib/donetick/config:/config:rw"
      "/var/lib/donetick/data:/donetick-data:rw"
      "${config.age.secrets."donetick.yaml".path}:/config/selfhosted.yaml"
    ];
    ports = [
      "2021:2021/tcp"
    ];
  };
  services.nginx.virtualHosts = {
    ${donetickUrl} = {
      forceSSL = true;
      sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
      sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2021";
      };
    };
  };
}
