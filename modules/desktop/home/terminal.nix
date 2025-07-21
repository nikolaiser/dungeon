{ lib, config, ... }:
{

  systemd.user.sessionVariables."TERMCMD" = "${lib.exe config.programs.foot.package}";
  programs.foot = {
    enable = true;
    server.enable = true;
  };
}
