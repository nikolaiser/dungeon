{
  config,
  pkgs,
  lib,
  ...
}:

let
  screenshotScript = pkgs.writeShellScript "screenshot" ''
    ${pkgs.darwin.system_cmds}/bin/screencapture -ic
  '';
in
{
  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          left = 10;
          right = 10;
          top = 10;
          bottom = 10;
        };
      };
      mode.main.binding = {
        cmd-1 = "workspace 1";
        cmd-2 = "workspace 2";
        cmd-3 = "workspace 3";
        cmd-4 = "workspace 4";
        cmd-5 = "workspace 5";
        cmd-6 = "workspace 6";
        cmd-7 = "workspace 7";
        cmd-8 = "workspace 8";
        cmd-9 = "workspace 9";
        cmd-0 = "workspace 10";

        cmd-shift-1 = "move-node-to-workspace 1 --focus-follows-window";
        cmd-shift-2 = "move-node-to-workspace 2 --focus-follows-window";
        cmd-shift-3 = "move-node-to-workspace 3 --focus-follows-window";
        cmd-shift-4 = "move-node-to-workspace 4 --focus-follows-window";
        cmd-shift-5 = "move-node-to-workspace 5 --focus-follows-window";
        cmd-shift-6 = "move-node-to-workspace 6 --focus-follows-window";
        cmd-shift-7 = "move-node-to-workspace 7 --focus-follows-window";
        cmd-shift-8 = "move-node-to-workspace 8 --focus-follows-window";
        cmd-shift-9 = "move-node-to-workspace 9 --focus-follows-window";
        cmd-shift-0 = "move-node-to-workspace 10 --focus-follows-window";

        cmd-left = "focus left";
        cmd-right = "focus right";
        cmd-up = "focus up";
        cmd-down = "focus down";

        cmd-shift-left = "move left";
        cmd-shift-right = "move right";
        cmd-shift-up = "move up";
        cmd-shift-down = "move down";

        cmd-j = "exec-and-forget open -a \"Raycast\"";
        cmd-b = "exec-and-forget open -n -a \"Google Chrome\"";
        cmd-shift-enter = "exec-and-forget ${lib.exe pkgs.alacritty}";
        cmd-shift-l = "close";
        cmd-s = "exec-and-forget ${screenshotScript}/bin/screenshot";

      };
    };
  };

  system.defaults = {
    spaces.spans-displays = false;
    dock.expose-group-apps = true;
  };

  environment.systemPackages = with pkgs; [
    autoraise
  ];

  homebrew.casks = [
    "mediosz/tap/swipeaerospace"
  ];

}
