{
  dungeon.desktop.nixos =
    { pkgs, ... }:
    {

      services = {
        udev.packages = with pkgs; [
          via
          vial
        ];
      };

      hardware.keyboard.qmk.enable = true;
    };
}
