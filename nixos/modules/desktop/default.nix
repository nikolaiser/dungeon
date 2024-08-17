args@{ lib, config, pkgs, ... }:

{
  options.desktop.enable = lib.mkEnableOption "Enable desktop role";
  config = lib.mkIf config.desktop.enable
    (lib.mkMerge [
      (import ./system args)
      {
        home-manager = {
          users.${config.username}.imports = [ ./home ];
          backupFileExtension = "backup";
        };
      }
    ]);
}
