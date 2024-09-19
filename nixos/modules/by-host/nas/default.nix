args@{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.networking.hostName == "nas") (
    lib.mkMerge [
      (import ./database.nix args)
    ]
  );

}
