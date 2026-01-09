{ inputs, ... }:
{

  nix-homebrew = {
    taps = {
      "acsandmann/tap" = inputs.acsandmann-tap;
    };
  };
  homebrew = {
    brews = [
      "rift"
    ];

    casks = [
      "hammerspoon"
    ];
  };

}
