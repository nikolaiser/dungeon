{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    freecad-qt6
    prusa-slicer
    pkgs-stable.orca-slicer
  ];

  # https://github.com/danth/stylix/pull/264
  xdg = {
    dataFile = {
      "FreeCAD/Mod/Stylix/Stylix/Stylix.cfg".text = import ./freecad/cfg.nix config lib;
      "FreeCAD/Mod/Stylix/Stylix/Stylix.qss".text = import ./freecad/stylesheet.nix config;
      "FreeCAD/Mod/Stylix/package.xml".text = import ./freecad/package.nix config;
    };
    configFile.PrusaSlicer = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/nixos/modules/cad/home/prusa-slicer";
      recursive = true;
    };

  };

}
