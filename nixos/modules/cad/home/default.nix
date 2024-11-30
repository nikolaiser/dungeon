{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs; [
    freecad-wayland
    prusa-slicer
    pkgs-stable.orca-slicer
  ];
}
