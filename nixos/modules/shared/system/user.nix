{ config, pkgs, ... }:

{

  users.users.${config.username} = {
    isNormalUser = true;
    home = "/home/${config.username}";
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
