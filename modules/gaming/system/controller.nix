{ pkgs, ... }:

{

  # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
  hardware.bluetooth.settings = {
    General = {
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  hardware = {
    steam-hardware.enable = true;
  };

  # https://github.com/ValveSoftware/steam-for-linux/issues/9310#issuecomment-2166248312
  boot = {
    kernelModules = [
      "hid_microsoft" # Xbox One Elite 2 controller driver preferred by Steam
    ];
    blacklistedKernelModules = [ "hid_xpadneo" ]; # This might interfere with the preferred driver if not blocked
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "xbox-one-elite-2-udev-rules";
      text = ''KERNEL=="hidraw*", TAG+="uaccess"'';
      destination = "/etc/udev/rules.d/60-xbox-elite-2-hid.rules";
    })
  ];

}
