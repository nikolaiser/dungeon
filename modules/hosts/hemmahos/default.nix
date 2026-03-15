{ dungeon, den, ... }:
{

  den.hosts.x86_64-linux.hemmahos.users.nikolaiser = {
    aspect = "hemmahos-nikolaiser";
  };

  den.aspects.hemmahos-nikolaiser = den.lib.parametric {
    includes = with dungeon; [
      agenix
      avahi
      cad._.prusa-slicer
      default
      den._.primary-user
      desktop
      desktop._.hyprland
      docker
      gaming._.controller._.xbox-elite
      gaming._.launchers
      gaming._.steam
      hardware._.bluetooth
      hardware._.firmware
      hardware._.gpu._.amd
      nix
      nvim._.full
      nvim._.wrapped
      overlays
      shell
      sound
      stylix
      systemd-boot
      zfs
    ];

  };

}
