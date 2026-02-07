{ den, ... }:
let
  allowAllUnfree =
    { host, ... }:
    {
      all = {
        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
      };
    };
in
{
  den.default = den.lib.parametric {
    includes = [ allowAllUnfree ];
  };
}
