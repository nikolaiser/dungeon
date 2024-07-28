{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
      };
    };
    supportedFilesystems = [ "zfs" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
