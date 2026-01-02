{
  pkgs,
  lib,
  config,
  ...
}:
{

  # systemd.user.services.krita = {
  #   Unit = {
  #     Description = "Krita";
  #     After = [
  #       "hyprland-session.target"
  #       "opentabletdriver.service"
  #     ];
  #     Wants = [ "opentabletdriver.service" ];
  #     PartOf = [ "hyprland-session.target" ];
  #   };
  #
  #   Install = {
  #     WantedBy = [ "hyprland-session.target" ];
  #   };
  #
  #   Service = {
  #     ExecStart = "${lib.getExe pkgs.krita}";
  #   };
  # };

  wayland.windowManager.hyprland = {
    settings = {

      bind = [

      ];

    };
  };
}
