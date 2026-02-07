{
  dungeon.smart.nixos =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {

      services.smartd = {
        enable = true;
        autodetect = true;
        notifications = {
          test = false;
          mail = {
            enable = true;
            mailer =
              let
                systemNotify = pkgs.writeShellScriptBin "smart-notify" ''
                  credentials=$(${pkgs.coreutils}/bin/cat ${config.age.secrets."ntfy-credentials".path})
                  content=$(${pkgs.coreutils}/bin/cat)
                  ${pkgs.curl}/bin/curl -d "$content" -u "$credentials" https://ntfy.${config.nas.baseDomain.public}/system
                '';
              in
              lib.getExe systemNotify;
          };
        };
      };
    };
}
