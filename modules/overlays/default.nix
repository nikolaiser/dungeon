{ den, ... }:
let
  overlays = inputs': [
    (_: prev: {
      fish = inputs'.nixpkgs-stable.legacyPackages.fish;
      # metals = inputs'.nixpkgs-stable.legacyPackages.metals;
      ghostty-bin = inputs'.nixpkgs-stable.legacyPackages.ghostty-bin;
      paperless-ngx = inputs'.nixpkgs-stable.legacyPackages.paperless-ngx;
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
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/25.11";
    };

    nixpkgs-omada.url = "github:pathob/NixOS-nixpkgs/omada-sdn-controller";
  };

  dungeon.overlays = den.lib.parametric {
    includes = [ aspect ];
  };
}
