{ config, lib, ... }:

{
  boot = {
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };

  services.displayManager = {
    ly.enable = lib.mkForce false;
    gdm.enable = true;
    autoLogin = {
      enable = true;
      user = config.shared.username;
    };
  };
}
