{

  dungeon.desktop._.sway.homeManager =
    {
      pkgs,
      lib,
      osConfig ? null,
      config,
      ...
    }:

    let
      mainMod = "Mod4";
      secondaryMod = "Mod4+Shift";

      syncClipboard =
        pkgs.writeShellScript "sync-clipboard" # bash
          ''
            echo -n "$(wl-paste -n)" | ${lib.getExe pkgs.xclip} -selection clipboard && \
              ${lib.getExe pkgs.libnotify} --urgency=low -t 2000 'Sway' 'Synced Wayland clipboard with X11' || \
              ${lib.getExe pkgs.libnotify} --urgency=critical -t 2000 'Sway' 'Clipboard sync failed'
          '';

    in
    {

      systemd.user.sessionVariables = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "MOZ_WEBRENDER" = "1";
        "_JAVA_AWT_WM_NONREPARENTING" = "1";
        "GTK_USE_PORTAL" = "1";
        "GTK_DEBUG" = "portals";
        "GDK_BACKEND" = "wayland,x11";
        "QT_QPA_PLATFORM" = "wayland;xcb";
        "SDL_VIDEODRIVER" = "wayland";
        "CLUTTER_BACKEND" = "wayland";
        "XCURSOR_THEME" = "${osConfig.stylix.cursor.name}";
        "XCURSOR_SIZE" = "${toString osConfig.stylix.cursor.size}";
      };

      wayland.windowManager.sway = {
        enable = true;
        extraSessionCommands = ''
          export XDG_CURRENT_DESKTOP=sway
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
        '';
        systemd = {
          enable = true;
          variables = [ "--all" ];
          xdgAutostart = true;
        };

        config = {
          modifier = mainMod;

          # output = {
          #   "DP-1" = {
          #     resolution = "3840x2160@144Hz";
          #     position = "0 0";
          #     scale = "1";
          #   };
          #   "DP-3" = {
          #     resolution = "3840x2160@144Hz";
          #     position = "0 0";
          #     scale = "1";
          #   };
          #   "DP-4" = {
          #     resolution = "3840x2160@144Hz";
          #     position = "0 0";
          #     scale = "1";
          #   };
          #   "eDP-1" = {
          #     resolution = "1920x1200@60Hz";
          #     position = "3840 1538";
          #     scale = "1";
          #   };
          #   "*" = {
          #     resolution = "preferred";
          #     position = "auto";
          #     scale = "auto";
          #   };
          # };

          input = {
            "type:keyboard" = {
              xkb_layout = "us,ru";
              xkb_options = "grp:alt_shift_toggle";
            };
            "type:touchpad" = {
              natural_scroll = "enabled";
              tap = "enabled";
            };
          };

          focus = {
            followMouse = true;
          };

          gaps = {
            inner = 5;
            outer = 10;
          };

          window = {
            border = 2;
          };

          bars = [ ];

          startup = [
            { command = "noctalia-shell"; }
          ];

          keybindings = lib.mkOptionDefault {
            "${secondaryMod}+Return" = "exec ${lib.getExe config.programs.ghostty.package}";
            "${secondaryMod}+l" = "kill";
            "${mainMod}+j" = "exec noctalia-shell ipc call launcher toggle";
            "${mainMod}+b" = "exec librewolf";

            "${mainMod}+quotedbl" = "splitv";
            "${mainMod}+backslash" = "splith";

            "${mainMod}+1" = "workspace number 1";
            "${mainMod}+2" = "workspace number 2";
            "${mainMod}+3" = "workspace number 3";
            "${mainMod}+4" = "workspace number 4";
            "${mainMod}+5" = "workspace number 5";
            "${mainMod}+6" = "workspace number 6";
            "${mainMod}+7" = "workspace number 7";
            "${mainMod}+8" = "workspace number 8";
            "${mainMod}+9" = "workspace number 9";
            "${mainMod}+0" = "workspace number 10";

            "${mainMod}+Left" = "focus left";
            "${mainMod}+Right" = "focus right";
            "${mainMod}+Up" = "focus up";
            "${mainMod}+Down" = "focus down";

            "${secondaryMod}+Left" = "move left";
            "${secondaryMod}+Right" = "move right";
            "${secondaryMod}+Up" = "move up";
            "${secondaryMod}+Down" = "move down";

            "${secondaryMod}+1" = "move container to workspace number 1";
            "${secondaryMod}+2" = "move container to workspace number 2";
            "${secondaryMod}+3" = "move container to workspace number 3";
            "${secondaryMod}+4" = "move container to workspace number 4";
            "${secondaryMod}+5" = "move container to workspace number 5";
            "${secondaryMod}+6" = "move container to workspace number 6";
            "${secondaryMod}+7" = "move container to workspace number 7";
            "${secondaryMod}+8" = "move container to workspace number 8";
            "${secondaryMod}+9" = "move container to workspace number 9";
            "${secondaryMod}+0" = "move container to workspace number 10";

            "${secondaryMod}+v" = "exec ${syncClipboard}";

            "${mainMod}+s" =
              "exec ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | ${lib.getExe pkgs.swappy} -f -";

            "${mainMod}+l" = "exec ${lib.getExe pkgs.swaylock} -f";

            "${mainMod}+Tab" = "workspace back_and_forth";

            "${mainMod}+minus" = "scratchpad show";
            "${secondaryMod}+minus" = "move scratchpad";

            "${mainMod}+r" = "mode resize";

            "XF86AudioPrev" = "exec ${lib.getExe pkgs.playerctl} previous";
            "XF86AudioPlay" = "exec ${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioNext" = "exec ${lib.getExe pkgs.playerctl} next";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessUp" = "exec ${lib.getExe pkgs.brightnessctl} set +5%";
            "XF86MonBrightnessDown" = "exec ${lib.getExe pkgs.brightnessctl} set 5%-";
          };

          modes = {
            resize = {
              "Left" = "resize shrink width 10 px";
              "Right" = "resize grow width 10 px";
              "Up" = "resize shrink height 10 px";
              "Down" = "resize grow height 10 px";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
          };

          floating = {
            modifier = mainMod;
          };
        };

        extraConfig = ''
          # Force zero scaling for xwayland
          for_window [shell="xwayland"] title_format "[X] %title"

          # Disable middle click paste
          bindsym --whole-window button2 nop
        '';
      };

      programs = {
        swaylock.enable = true;
        fuzzel.enable = true;
      };

      services = {
        swaync.enable = true;
      };
    };
}
