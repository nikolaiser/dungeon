{ lib, ... }:
{

  init = lib.mkEnableOption "Init server";
  ip = lib.mkOption {
    description = "Node IP";
    type = lib.types.str;
    default = "";
  };
}
