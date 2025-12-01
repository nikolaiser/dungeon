{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  baseConfiguration = inputs.self.nixosConfigurations.baseImageNetbootx86_64.config.system.build;
in
{
  services.pixiecore = {
    enable = true;
    mode = "boot";
    kernel = "${baseConfiguration.kernel}/bzImage";
    initrd = "${baseConfiguration.netbootRamdisk}/initrd";
    cmdLine = "init=${baseConfiguration.toplevel}/init";
    openFirewall = true;
    port = 8283;
  };

  networking.firewall.allowedTCPPorts = [ 8181 ];
  networking.firewall.allowedUDPPorts = [ 4011 ];

}
