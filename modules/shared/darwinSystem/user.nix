{ config, pkgs, ... }:

{

  system.primaryUser = config.shared.username;

  users.knownUsers = [ config.shared.username ];

  users.users.${config.shared.username} = {
    home = "/Users/${config.shared.username}";
    shell = pkgs.fish;
    uid = 502;
  };

  home-manager.backupFileExtension =
    "backup-"
    + pkgs.lib.readFile "${pkgs.runCommand "timestamp" { } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

}
