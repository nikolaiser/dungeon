{ lib, config, ... }:

{
  options.cad.enable = lib.mkEnableOption "Enable gaming presets";

  config = lib.mkIf config.cad.enable {

    home-manager.users.${config.username}.imports = [ ./home ];
  };

}
