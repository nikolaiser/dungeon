{ inputs, ... }:
{
  flake-file.inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    gyg-dev = {
      url = "git+ssh://git@github.com/getyourguide/dev";
      flake = false;
    };
  };

  dungeon.desktop = {
    includes = [
      (
        { user, ... }:
        {
          darwin.nix-homebrew.user = user.userName;
        }
      )
    ];

    darwin =
      { config, ... }:
      {

        imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

        nix-homebrew = {
          # Install Homebrew under the default prefix
          enable = true;

          # New
          enableFishIntegration = true;

          # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
          enableRosetta = true;

          # Automatically migrate existing Homebrew installations
          autoMigrate = true;

          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
            "getyourguide/homebrew-dev" = inputs.gyg-dev;
          };
        };

        homebrew = {

          enable = true;
          brews = [
            "dev-bundle"
          ];
          casks = [
            "betterdisplay"
          ];
          taps = builtins.attrNames config.nix-homebrew.taps;

        };
      };
  };
}
