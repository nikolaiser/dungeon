{

  dungeon.desktop = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.supersonic-wayland ];
      };
  };
}
