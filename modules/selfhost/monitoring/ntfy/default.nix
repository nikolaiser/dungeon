{ dungeon, den, ... }:
{

  dungeon = {
    overlays = den.lib.parametric {
      includes = [ 
    ({
      nixos = args: {
        nixpkgs.overlays = [
          ((import ./_overlay.nix) args)
        ];
      };
      
    })];
    };
  };

  den.default.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ntfy-curl ];
    };
}
