{ config, lib, ... }:

{
  options.systemd-boot.enable = lib.mkEnableOption "Enable systemd-boot";

  config = lib.mkIf config.systemd-boot.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
        };
      };
      binfmt.emulatedSystems = [ "aarch64-linux" ];
    };
  };
}
