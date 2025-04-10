{
  inputs,
  system,
  config,
  ...
}:
{

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];

  nix.settings = {
    substituters = [ "https://cache.saumon.network/proxmox-nixos" ];
    trusted-public-keys = [ "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys=" ];
  };

  services.proxmox-ve = {
    enable = true;
    ipAddress = "10.10.163.211";
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "pve.${config.nas.baseDomain.private}" = {
      forceSSL = true;
      useACMEHost = "${config.nas.baseDomain.private}";
      locations."/" = {
        proxyPass = "https://10.10.163.211:8006";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 10000M;
        '';
      };
    };
  };

}
