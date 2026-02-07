{ inputs, den, ... }:
let
  aspect =

    { host, ... }:
    {

      ${host.class} =
        { pkgs, ... }:
        {
          nix = {
            nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
            settings = {
              experimental-features = [
                "nix-command"
                "flakes"
              ];
              nix-path = "nixpkgs=flake:nixpkgs";
              substituters = [ "https://nix-community.cachix.org" ];
              trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
            };
            package = pkgs.nixVersions.latest;
          };
        };

    };
in
{
  dungeon.nix = den.lib.parametric {
    includes = [ aspect ];
    # Because of determinate
    darwin.nix.enable = false;
  };
}
