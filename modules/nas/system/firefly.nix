{ config, ... }:

let
  fireflyUrl = "firefly.${config.nas.baseDomain.public}";
in
{
  services = {
    firefly-iii = {
      enable = true;
      settings = {
        APP_ENV = "production";
        APP_KEY_FILE = config.age.secrets."firefly-key.txt".path;
        SITE_OWNER = "mail@nikolaiser.com";
        DB_CONNECTION = "pgsql";
        DB_HOST = "10.10.163.211";
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.age.secrets."firefly-postgres-password.txt".path;
      };
      enableNginx = true;
      virtualHost = fireflyUrl;
    };

    nginx.virtualHosts = {
      ${fireflyUrl} = {
        forceSSL = true;
        sslCertificate = config.age.secrets."cloudflare-fullchain.pem".path;
        sslCertificateKey = config.age.secrets."cloudflare-privkey.pem".path;
      };
    };
  };

}
