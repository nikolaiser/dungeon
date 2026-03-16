{ inputs, ... }:
{
  flake-file.inputs = {
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";

    };
    # Demo on fetching plugins from outside nixpkgs
    plugins-brichka = {
      url = "github:nikolaiser/brichka.nvim";
      flake = false;
    };
    plugins-nightfox = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

  };

  dungeon.nvim._.wrapped = {
    os =
      {
        pkgs,
        lib,
        inputs',
        ...
      }:
      let

        module = (lib.modules.importApply ./_module.nix { inherit inputs inputs'; });
        wrapper = inputs.wrappers.lib.evalModule module;
      in
      {
        environment.systemPackages = [
          (wrapper.config.wrap { inherit pkgs; })
        ];
      };
  };
}
