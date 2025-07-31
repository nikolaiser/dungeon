{ pkgs, ... }:

{
  services.dbus.packages = [ pkgs.librewolf ];
}
