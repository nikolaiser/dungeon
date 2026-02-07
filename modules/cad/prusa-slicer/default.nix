{
  dungeon.cad._.prusa-slicer.homeManager =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        prusa-slicer
      ];
      xdg.configFile.PrusaSlicer = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/modules/cad/prusa-slicer/config";
        recursive = true;
      };
    };
}
