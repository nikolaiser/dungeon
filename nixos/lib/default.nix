{ lib, ... }:

{
  /*
    Return first binary executable name of the given derivation
    Type:
      exe :: Derivation -> String
  */
  exe =
    drv:
    let
      regFiles = lib.mapAttrsToList (f: _: f) (
        lib.filterAttrs (_: t: t == "regular") (builtins.readDir "${drv}/bin")
      );
      mainProg = drv.meta.mainProgram or (lib.head regFiles);
    in
    "${drv}/bin/${mainProg}";


}
