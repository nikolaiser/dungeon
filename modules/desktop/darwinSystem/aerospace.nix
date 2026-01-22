{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  screenshotScript = pkgs.writeShellScript "screenshot" ''
    ${pkgs.darwin.system_cmds}/bin/screencapture -ic
  '';
in
{

  system.defaults = {
    # spaces.spans-displays = false;
    dock.expose-group-apps = true;
  };

  # environment.systemPackages = with pkgs; [
  #   autoraise
  # ];
  #
  # homebrew.casks = [
  #   "mediosz/tap/swipeaerospace"
  # ];

}
