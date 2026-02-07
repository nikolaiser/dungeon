{ dungeon, den, ... }:
{

  den.hosts.aarch64-darwin.hemmahos.users."nikolai.sergeev" = {
    aspect = "gyg-nikolai.sergeev";
  };

  den.aspects."gyg-nikolai.sergeev" = den.lib.parametric {
    includes = with dungeon; [
      nix
      nvim._.full
      overlays
      shell
      stylix
      desktop
      desktop._.rift
      desktop._.colima
    ];

  };

}
