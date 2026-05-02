{ dungeon, den, ... }:
{

  den.hosts.x86_64-linux.nas.users.ops = {
    aspect = "nas-ops";
  };

  den.aspects.nas-ops = den.lib.parametric {
    includes = with dungeon; [
      default
      den._.primary-user
      docker
      hardware._.firmware
      ssh
      zfs
      agenix
      avahi
      shell
      overlays
      nix
      selfhost
      nvim._.wrapped
      hardware._.gpu._.amd
    ];

  };

}
