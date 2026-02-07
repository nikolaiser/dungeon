{
  den.aspects.mityan-ops.nixos =

    { lib, config, ... }:
    {
      boot = {
        extraModulePackages = [ ];
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-amd" ];
      };

      swapDevices = [ ];
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      networking = {
        networkmanager.enable = true;
        hostId = "50ac0cbe";
        hostName = "mityan";
      };
    };
}
