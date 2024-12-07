{
  pkgs,
  pkgs-stable,
  pkgs-freecad,
  config,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    pkgs-freecad.freecad-qt6
    prusa-slicer
    pkgs-stable.orca-slicer
  ];

  # https://github.com/danth/stylix/pull/264
  xdg.dataFile = {
    "FreeCAD/Mod/Stylix/Stylix/Stylix.cfg".text = import ./freecad/cfg.nix config lib;
    "FreeCAD/Mod/Stylix/Stylix/Stylix.qss".text = import ./freecad/stylesheet.nix config;
    "FreeCAD/Mod/Stylix/package.xml".text = import ./freecad/package.nix config;
  };

}
