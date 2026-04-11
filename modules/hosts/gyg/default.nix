{ dungeon, den, ... }:
{

  den.hosts.aarch64-darwin.gyg.users."nikolai.sergeev" = {
    aspect = den.aspects."gyg-nikolai.sergeev";
  };

  den.aspects."gyg-nikolai.sergeev" = den.lib.parametric {
    includes = with dungeon; [
      stylix
      nix
      # nvim._.full
      nvim._.wrapped
      den._.primary-user
      default
      overlays
      shell
      desktop
      desktop._.rift
      desktop._.colima
    ];

  };

}
