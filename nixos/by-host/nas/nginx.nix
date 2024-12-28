{
  config,
  ...
}:

{
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "mail@nikolaiser.com";
    };
    certs."${config.baseDomain.private}" = {
      domain = "*.${config.baseDomain.private}";
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      environmentFile = config.age.secrets."acmeCloudflare.env".path;
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

}
