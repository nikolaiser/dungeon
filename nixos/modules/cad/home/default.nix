{ pkgs, ... }:

{
  home.packages = with pkgs; [
    freecad-wayland
    prusa-slicer
    orca-slicer
  ];
}
