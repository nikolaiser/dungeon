{ lib, config, ... }:

{
  options.cad.enable = lib.mkEnableOption "Enable gaming presets";

  config = lib.mkIf config.cad.enable (
    lib.mkMerge [
      {
        home-manager.users.${config.username}.imports = [ ./home ];
      }
    ]
  );

}
