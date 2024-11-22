{
  pkgs,
  lib,
  config,
  ...
}:

with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;
    style =
      ''
        @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
        @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

        @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
        @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

        * {
            font-family: "${sansSerif.name}";
            font-size: ${builtins.toString sizes.desktop}pt;
        }

        window#waybar, tooltip {
            background: alpha(@base00, ${with config.stylix.opacity; builtins.toString desktop});
            color: @base05;
        }

        tooltip {
            border-color: @base0D;
        }
      ''
      + (builtins.readFile ./style.css)
      + (import ./colors.nix "left")
      + (import ./colors.nix "center")
      + (import ./colors.nix "right");

    settings = {
      "bar" = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        mod = "dock";
        height = 44;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [
          "clock"
          "pulseaudio"
          # "pulseaudio#microphone"
        ];
        modules-right = [
          # "network"
          "battery"
          "tray"
          "hyprland/language"
          "custom/powermenu"
        ];

        "pulseaudio" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-bluetooth" = "{icon} {volume}% {format_source}";
          "format-bluetooth-muted" = "   {volume}% {format_source}";
          "format-muted" = "  {format_source}";
          "format-source" = " ";
          "format-source-muted" = " ";
          "format-icons" = {
            "headphone" = " ";
            "hands-free" = " ";
            "headset" = " ";
            "phone" = " ";
            "portable" = " ";
            "car" = " ";
            "default" = [
              " "
              " "
              " "
            ];
          };
          "tooltip-format" = "{desc}, {volume}%";
        };

        "pulseaudio#microphone" = {
          "format" = "{format_source}";
          "format-source" = "Mic: {volume}%";
          "format-source-muted" = "Mic: Muted";
          "scroll-step" = 5;
        };

        "custom/powermenu" = {
          "format" = "  ";
          "on-click" = "${lib.exe pkgs.wlogout}";
          "tooltip" = "false";
        };
      };
    };

    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };
}
