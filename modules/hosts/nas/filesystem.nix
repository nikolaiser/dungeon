{

  den.aspects.nas-ops.nixos.fileSystems = {
    "/" = {
      device = "nvme/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "nvme/home";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/nix" = {
      device = "nvme/nix";
      fsType = "zfs";
    };
    "/nvmeStorage" = {
      device = "nvme/nvmeStorage";
      fsType = "zfs";
    };
    "/home/ops/.local/share/atuin" = {
      device = "/dev/zvol/nvme/atuin";
      fsType = "ext4";
    };
    "/boot1" = {
      device = "/dev/disk/by-uuid/3C2A-02AE";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/boot2" = {
      device = "/dev/disk/by-uuid/3C5F-136A";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}
