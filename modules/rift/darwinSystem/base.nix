{ inputs, ... }:
{

  nix-homebrew = {
    taps = {
      "acsandmann/homebrew-tap" = inputs.acsandmann-tap;
    };
  };
  homebrew = {
    brews = [
      "rift"
    ];

    # casks = [
    #   "hammerspoon"
    # ];
  };

}
