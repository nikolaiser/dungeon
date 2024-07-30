{ lib, ... }:

{

  imports = [
    ./system/base.nix
    ./system/bootloader.nix
    ./system/zfs.nix
    ./system/user.nix
  ];

  options.username = lib.mkOption {
    description = "Username";
    type = lib.types.str;
  };

}
