{

  dungeon.desktop = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.feishin ];
      };
  };
}
