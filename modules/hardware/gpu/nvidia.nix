{
  dungeon.hardware._.gpu._.nvidia.nixos = {

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics.enable = true;
      nvidia.open = true;
    };
  };
}
