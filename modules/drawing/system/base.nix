{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    krita
    vscode
  ];
  boot.plymouth.enable = true;

}
