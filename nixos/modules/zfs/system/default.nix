_:

{

  boot.kernelParams = [ "nohibernate" ];
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;
}
