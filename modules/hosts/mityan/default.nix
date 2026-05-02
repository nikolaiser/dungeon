{ dungeon, den, ... }:
{
  den.hosts.x86_64-linux.mityan.users.ops = {
    aspect = "mityan-ops";
  };

  den.aspects.mityan-ops = den.lib.parametric {
    includes = with dungeon; [
      default
      den._.primary-user
      docker
      gaming._.controller._.base
      gaming._.gamescope-boot
      gaming._.steam
      hardware._.bluetooth
      hardware._.firmware
      hardware._.gpu._.nvidia
      sound
      ssh
      systemd-boot
      zfs
      agenix
      avahi
      shell
      overlays
      nix
    ];

  };

}
