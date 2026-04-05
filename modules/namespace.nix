{ inputs, ... }:
{

  flake-file.inputs.private = {
    url = "git+ssh://git@github.com/nikolaiser/dungeon-private";
    inputs.den.follows = "den";
    inputs.flake-parts.follows = "flake-parts";
    inputs.import-tree.follows = "import-tree";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    (inputs.den.namespace "dungeon" [
      false
      inputs.private
    ])
  ];
}
