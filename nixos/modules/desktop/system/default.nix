args@{ lib, ... }:

args.lib.mkMerge [
  (import ./base.nix args)
  (import ./bluetooth.nix)
  (import ./gaming.nix)
  (import ./hyprland.nix args)
  (import ./keyboard.nix args)
  (import ./network.nix args)
  (import ./sound.nix)
  (import ./stylix.nix args)
  (import ./user.nix args)
  (import ./yubikey.nix args)
]

