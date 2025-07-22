{
  pkgs,
  config,
  ...
}:

let
  ntfy-curl = pkgs.writeShellScriptBin "ntfy-curl" ''
    credentials=$(${pkgs.coreutils}/bin/cat ${config.age.secrets."ntfy-credentials".path})
    ${pkgs.curl}/bin/curl -u "$credentials" "$@"
  '';
in
{
  environment.systemPackages = [ ntfy-curl ];
}
