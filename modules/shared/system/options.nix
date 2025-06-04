{ lib, ... }:

{

  username = lib.mkOption {
    description = "Username";
    type = lib.types.str;
  };

}
