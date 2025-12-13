{ config, pkgs, ... }:
{
  boot = {
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    gamescope-wsi # HDR won't work without this
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam.gamescopeSession.enable = true;

  services.xserver.enable = false;
  services.getty.autologinUser = config.shared.username;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = config.shared.username;
        command = "${pkgs.gamescope}/bin/gamescope  -W 3840 -H 2160 -f -e --xwayland-count 2 --hdr-enabled --hdr-itm-enabled -- ${pkgs.steam}/bin/steam -tenfoot > /dev/null 2>&1";
      };
    };
  };

}
