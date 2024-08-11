{ lib, config, ... }:

{
  options.vpn.enable = lib.mkEnableOption "Enable vpn client";
}
