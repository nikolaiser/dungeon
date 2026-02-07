{ den, ... }:
let
  overlays = inputs': [
    (_: prev: {
      fish = inputs'.nixpkgs-stable.legacyPackages.fish;
      omada-software-controller =
        inputs'.nixpkgs-omada.legacyPackages.omada-software-controller.overrideAttrs
          (final: prev: { meta.license.free = true; });
    })
  ];

  overlaysModule =
    { pkgs, inputs', ... }:
    {
      nixpkgs.overlays = (overlays inputs');
    };

  aspect =
    { host, ... }:
    {
      os = overlaysModule;
      homeManager = overlaysModule;
    };

in
{

  flake-file.inputs = {
    nixpkgs-fish-4-3-3 = {
      url = "github:nixos/nixpkgs/f3910d1ac9cbc72fab194a22fd2a774c9e0f872f";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/25.11";
    };

    nixpkgs-omada.url = "github:pathob/NixOS-nixpkgs/omada-sdn-controller";
  };

  dungeon.overlays = den.lib.parametric {
    includes = [ aspect ];
  };
}
