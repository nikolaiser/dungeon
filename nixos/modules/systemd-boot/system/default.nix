_: {

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
      };
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
