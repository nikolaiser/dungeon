{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    raycast
  ];

  system.defaults.dock.autohide = true;

  homebrew.enable = true;
}
