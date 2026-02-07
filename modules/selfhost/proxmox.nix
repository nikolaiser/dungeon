{ inputs, ... }:
{
  # flake-file.inputs.proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  flake-file.inputs.proxmox-nixos.url = "github:greg-hellings/proxmox-nixos/fix/212-AcceptEnv-redefinition";

  dungeon.selfhost.nixos =
    {
      config,
      ...
    }:
    {

      imports = [ inputs.proxmox-nixos.nixosModules.proxmox-ve ];

      nixpkgs.overlays = [
        inputs.proxmox-nixos.overlays.x86_64-linux
      ];

      nix.settings = {
        substituters = [ "https://cache.saumon.network/proxmox-nixos" ];
        trusted-public-keys = [ "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM=" ];
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

    };
}
