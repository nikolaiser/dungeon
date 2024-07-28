{ lib, ... }:

{

  imports = [
    ./system/base.nix
    ./system/bootloader.nix
    ./system/zfs.nix
  ];

  options.username = lib.mkOption {
    description = "Username";
    type = lib.types.str;
  };

}
