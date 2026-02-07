{
  flake-file.inputs.zwift = {
    url = "github:netbrain/zwift";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  dungeon.gaming._.zwift.nixos =
    { inputs, ... }:
    {
      imports = [ inputs.zwift.nixosModules.zwift ];

      programs.zwift.enable = true;
    };
}
