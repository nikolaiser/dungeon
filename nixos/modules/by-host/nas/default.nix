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
      (import ./automation.nix args)
      (import ./database.nix args)
      (import ./iscsi.nix args)
      (import ./nfs.nix)
      (import ./nginx.nix args)
      (import ./pixiecore args)
      (import ./proxy.nix args)
      (import ./seafile.nix args)
      (import ./vaultwarden.nix args)
    ]
  );

}
