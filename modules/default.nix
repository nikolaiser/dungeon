{
  den,
  dungeon,
  lib,
  ...
}:
let

  all-class =
    { class, aspect-chain }:
    den._.forward {
      each = [
        "nixos"
        "darwin"
        "homeManager"
      ];
      fromClass = _: "all";
      intoClass = lib.id;
      intoPath = _: [ ];
      fromAspect = _: lib.head aspect-chain;
    };

in
{
  den.default = {
    includes = [
      # den._.home-manager
      den._.define-user
      den._.inputs'
      den._.self'
      all-class
      dungeon.smart
    ];
    darwin.system.stateVersion = 6;
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";

    os = {
      time.timeZone = "Europe/Berlin";
    };
  };

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

}
