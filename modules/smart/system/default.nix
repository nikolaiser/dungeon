{
  config,
  pkgs,
  lib,
  ...
}:

let
  systemNotify = pkgs.writeShellScriptBin "smart-notify" ''
    credentials=$(${pkgs.coreutils}/bin/cat ${config.age.secrets."ntfy-credentials".path})
    content=$(${pkgs.coreutils}/bin/cat)
    ${pkgs.curl}/bin/curl -d "$content" -u "$credentials" https://ntfy.${config.nas.baseDomain.public}/system
  '';
in
{

  services.smartd = {
    enable = true;
    autodetect = true;
    notifications = {
      test = false;
      mail = {
        enable = true;
        mailer = lib.getExe systemNotify;
      };
    };
  };

}
