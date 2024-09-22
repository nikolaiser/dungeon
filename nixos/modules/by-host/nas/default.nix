args@{
  config,
  lib,
  pkgs,
  ...
}:

{

  options.baseDomain = {

    public = lib.mkOption {
      description = "Base domain for services that are open to the internet";
      type = lib.types.str;
      default = "";
    };

    private = lib.mkOption {
      description = "Base domain for services that are open to the LAN only";
      type = lib.types.str;
      default = "";
    };

  };

  config = lib.mkIf (config.networking.hostName == "nas") (
    lib.mkMerge [
      (import ./database.nix args)
      (import ./nginx.nix args)
      (import ./vaultwarden.nix args)
      (import ./pixiecore args)
    ]
  );

}
