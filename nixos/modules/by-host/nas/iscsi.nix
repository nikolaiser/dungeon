{ config, lib, ... }:

{

  services = {
    target.enable = true;
    openiscsi = {
      enable = true;
      name = "iqn.2000-05.edu.example.iscsi:${config.networking.hostName}";
    };
  };

  environment.etc."target/saveconfig.json".enable = lib.mkForce false;

  networking.firewall.allowedTCPPorts = [ 3260 ];

  # For iSCSI 
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAV+ApypErxA5ppmCF3V7dcolkST95czMOviMl1LsAz iscsi@example.com"
  ];

  services.openssh.settings.PermitRootLogin = "yes";

}
