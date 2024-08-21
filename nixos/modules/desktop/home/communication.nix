{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    slack
    telegram-desktop
    webcord
  ];
}
