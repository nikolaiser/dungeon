{
  config,
  ...
}:

{
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];

}
