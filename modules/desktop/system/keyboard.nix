{ pkgs, ... }:

{
  services = {
    # xserver.xkb = {
    #   layout = "us,ru";
    #   options = "grp:alt_shift_toggle";
    # };

    udev.packages = with pkgs; [
      via
      vial
    ];
  };

  hardware.opentabletdriver.enable = true;

  boot.blacklistedKernelModules = [
    "wacom"
    "hid_uclogic"
  ];

  hardware.keyboard.qmk.enable = true;

  # # Powertop - don't turn off some peripherals
  # systemd.services.powertop.postStart = ''
  #   HIDDEVICES=$(ls /sys/bus/usb/drivers/usbhid | grep -oE '^[0-9]+-[0-9\.]+' | sort -u)
  #   for i in $HIDDEVICES; do
  #     echo -n "Enabling " | cat - /sys/bus/usb/devices/$i/product
  #     echo 'on' > /sys/bus/usb/devices/$i/power/control
  #   done
  # '';
}
