{ lib, ... }:

{

  imports = [
    ./system/base.nix
    ./system/user.nix
  ];

  options.username = lib.mkOption {
    description = "Username";
    type = lib.types.str;
  };

}
