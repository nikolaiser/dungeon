{ inputs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "tile,class:(zwiftapp.exe)" # don't float
    ];
  };
}
