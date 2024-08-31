{ pkgs, ... }:

{
  services = {
    xserver.xkb = {
      layout = "us,ru";
      options = "grp:alt_shift_toggle";
    };

    udev.packages = with pkgs; [ via vial ];
  };

  hardware.keyboard.qmk.enable = true;
}
