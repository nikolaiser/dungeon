{
  lib,
  config,
  pkgs,
  ...
}:
{

  systemd.user.sessionVariables."TERMCMD" = "${lib.exe config.programs.ghostty.package}";
}
