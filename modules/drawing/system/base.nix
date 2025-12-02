{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    krita
  ];
  boot.plymouth.enable = true;

}
