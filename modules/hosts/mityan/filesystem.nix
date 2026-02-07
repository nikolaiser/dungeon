{

  den.aspects.mityan-ops.nixos.fileSystems = {
    "/" = {
      device = "root/root";
      fsType = "zfs";
    };

    "/nix" = {
      device = "root/nix";
      fsType = "zfs";
    };

    "/home" = {
      device = "root/home";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9787-BDAE";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}
