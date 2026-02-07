{ den, ... }:
{

  dungeon.apply-overlay =
    overlay:
    { host, ... }:
    {
      all = args: {
        nixpkgs.overlays = [
          (overlay args)
        ];
      };
    };
}
