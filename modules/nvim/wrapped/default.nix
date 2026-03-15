{ inputs, ... }:
{
  flake-file.inputs = {
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";

    };
    # Demo on fetching plugins from outside nixpkgs
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    # These 2 are already in nixpkgs, however this ensures you always fetch the most up to date version!
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };

  };

  dungeon.nvim._.wrapped = {
    os =
      { pkgs, lib, ... }:
      let

        module = lib.modules.importApply ./_module.nix inputs;
        wrapper = inputs.wrappers.lib.evalModule module;
      in
      {
        environment.systemPackages = [
          (wrapper.config.wrap { inherit pkgs; })
        ];
      };
  };
}
