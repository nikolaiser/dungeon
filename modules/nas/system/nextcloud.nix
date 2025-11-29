{
  config,
  ...
}:

let
  nextcloudUrl = "nextcloud.${config.nas.baseDomain.public}";
in
{

  services = {
    nextcloud = {
      enable = true;
      hostName = nextcloudUrl;
      config = {
        adminpassFile = config.age.secrets."nextcloud-adminpass".path;
        dbtype = "pgsql";
        dbpassFile = config.age.secrets."nextcloud-postgres-password".path;
      };
    };

    nginx.virtualHosts = {
      ${nextcloudUrl} = {
        forceSSL = true;
        sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
        sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;

      };
    };
  };

}
