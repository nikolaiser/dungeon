{ pkgs, lib, ... }:

let
  mainMod = "SUPER";
  secondaryMod = "SUPER_SHIFT";
in
{
  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
      enableXdgAutostart = true;
    };

    settings = {

      monitor = [
        "DP-1,3840x2160@120,0x0,1"
        "DP-3,3840x2160@120,0x0,1"
        "eDP-1,1920x1200@60,3840x1538,1"
        "HDMI-A-1,disable"
        ",preferred,auto,auto"
      ];

      env = "XCURSOR_SIZE,24";

      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";

        follow_mouse = "1";

        touchpad.natural_scroll = "true";

        sensitivity = "0";
      };

      general = {
        gaps_in = "5";
        gaps_out = "10";
        border_size = "2";
        layout = "dwindle";
      };

      decoration = {
        rounding = "10";
        blur = {
          enabled = "true";
          size = "3";
          passes = "1";
        };
        drop_shadow = "true";
        shadow_range = "4";
        shadow_render_power = "3";
      };

      animations = {
        enabled = "true";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "true";
        preserve_split = "true";
      };

      bind = [
        "${secondaryMod}, RETURN, exec, ${lib.exe pkgs.foot}"
        "${secondaryMod}, C, killactive"
        "${mainMod}, P, exec, ${lib.exe pkgs.fuzzel}"
        "${mainMod}, J, togglesplit"

        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"

        "${secondaryMod}, 1, movetoworkspace, 1"
        "${secondaryMod}, 2, movetoworkspace, 2"
        "${secondaryMod}, 3, movetoworkspace, 3"
        "${secondaryMod}, 4, movetoworkspace, 4"
        "${secondaryMod}, 5, movetoworkspace, 5"
        "${secondaryMod}, 6, movetoworkspace, 6"
        "${secondaryMod}, 7, movetoworkspace, 7"
        "${secondaryMod}, 8, movetoworkspace, 8"
        "${secondaryMod}, 9, movetoworkspace, 9"
        "${secondaryMod}, 0, movetoworkspace, 10"

        "${mainMod}, S, exec, ${lib.exe pkgs.grim} -g \"$(${lib.exe pkgs.slurp})\" - | ${lib.exe pkgs.swappy} -f -"

        ", xF86AudioPrev, exec, ${lib.exe pkgs.playerctl} previous"
        ", xF86AudioPlay, exec, ${lib.exe pkgs.playerctl} play-pause"
        ", xF86AudioNext, exec, ${lib.exe pkgs.playerctl} next"
        ", code:198, exec, ${pkgs.alsa-utils}/bin/amixer set Capture toggle"
      ];

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      #windowrule = [ "tile, ^(VisualVM.*)$" ];

    };
  };

  programs = {
    swaylock.enable = true;
    fuzzel.enable = true;
  };

  services.mako = {
    enable = true;
  };
}
