{
  dungeon.cad.homeManager =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        freecad
      ];
    };
}
