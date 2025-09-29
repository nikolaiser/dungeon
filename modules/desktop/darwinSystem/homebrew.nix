{ config, ... }:
{

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "nikolai.sergeev";

    # Automatically migrate existing Homebrew installations
    autoMigrate = true;
  };

  homebrew = {

    enable = true;
    brews = [
      "dev-bundle"
    ];
    taps = builtins.attrNames config.nix-homebrew.taps;

  };
}
