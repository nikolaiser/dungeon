{
  config,
  lib,
  pkgs,
  ...
}:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
  zfsNotify = pkgs.writeShellScriptBin "zfs-notify" ''
    credentials=$(${pkgs.coreutils}/bin/cat ${config.age.secrets."ntfy-credentials".path})
    content=$(${pkgs.coreutils}/bin/cat)
    ${pkgs.curl}/bin/curl -d "$content" -u "$credentials" https://ntfy.${config.nas.baseDomain.public}/zfs
  '';

in
{

  boot = {
    kernelParams = [ "nohibernate" ];
    supportedFilesystems = [ "zfs" ];
    kernelPackages = latestKernelPackage;
  };
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    trim.enable = true;

    zed = {
      enableMail = true;
      settings = {
        ZED_EMAIL_ADDR = [ "void@void" ];
        ZED_EMAIL_PROG = lib.getExe zfsNotify;
        ZED_EMAIL_OPTS = "@SUBJECT@ @ADDRESS@";

        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_DATA = true;
        ZED_NOTIFY_VERBOSE = true;
      };
    };
  };
}
