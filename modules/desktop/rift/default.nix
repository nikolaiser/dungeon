{ inputs, ... }:
{

  flake-file.inputs.acsandmann-tap = {
    url = "github:acsandmann/homebrew-tap";
    flake = false;
  };

  dungeon.desktop._.rift = {
    darwin = {
      nix-homebrew = {
        taps = {
          "acsandmann/homebrew-tap" = inputs.acsandmann-tap;
        };
      };
      homebrew = {
        brews = [
          "rift"
        ];
      };
    };
    homeManager.home.file.".config/rift/config.toml".source = ./config.toml;
  };
}
