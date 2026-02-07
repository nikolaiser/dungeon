{ config, ... }:
final: _: {
  ntfy-curl = final.writeShellScriptBin "ntfy-curl" ''
    credentials=$(${final.coreutils}/bin/cat ${config.age.secrets."ntfy-credentials".path})
    ${final.curl}/bin/curl -u "$credentials" "$@"
  '';
}
