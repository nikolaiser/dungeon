{ dungeon, den, ... }:
{

  dungeon = {
    overlays = den.lib.parametric {
      includes = [ (dungeon.apply-overlay (import ./_overlay.nix)) ];
    };
  };

  den.default.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ntfy-curl ];
    };
}
