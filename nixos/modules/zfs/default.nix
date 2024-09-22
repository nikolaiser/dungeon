{ config, lib, ... }:

{
  options.zfs.enable = lib.mkEnableOption "Enable zfs support";

  config = lib.mkIf config.zfs.enable {
    boot.kernelParams = [ "nohibernate" ];
    boot.supportedFilesystems = [ "zfs" ];
  };
}
