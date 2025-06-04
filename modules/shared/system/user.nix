{ config, pkgs, ... }:

{

  users.users.${config.shared.username} = {
    isNormalUser = true;
    home = "/home/${config.shared.username}";
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

  home-manager.backupFileExtension =
    "backup-"
    + pkgs.lib.readFile "${pkgs.runCommand "timestamp" { } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

}
