{ inputs, ... }:

{
  home = {
    sessionPath = [ "$HOME/.local/bin" ];
    file = {
      "zwift.sh" = {
        source = inputs.zwift;
        target = ".local/bin/zwift";
        executable = true;
      };
    };
  };

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "tile,class:(zwiftapp.exe)" # don't float
    ];
  };
}
