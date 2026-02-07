{

  den.aspects.hemmahos-nikolaiser.nixos.fileSystems = {
    "/" = {
      device = "root/root";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F10A-6075";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/home" = {
      device = "root/home";
      fsType = "zfs";
    };
    "/home/nikolaiser/.local/share/atuin" = {
      device = "/dev/zvol/root/atuin";
      fsType = "ext4";
    };
    "/nix" = {
      device = "root/nix";
      fsType = "zfs";
    };
    "/var" = {
      device = "root/var";
      fsType = "zfs";
    };
  };
}
