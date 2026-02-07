{
  dungeon.desktop._.work.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ slack ];
    };
}
