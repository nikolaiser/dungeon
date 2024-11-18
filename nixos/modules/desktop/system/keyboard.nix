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
      wacomtablet
    ];
  };

  hardware.opentabletdriver.enable = true;

  environment.systemPackages = [ pkgs.wacomtablet ];

  hardware.keyboard.qmk.enable = true;
}
