{
  den.aspects.hemmahos-nikolaiser.nixos =

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
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-amd" ];
        kernelParams = [
          "amd_pstate=guided"
          "pcie_aspm=force"
        ];
        zfs = {
          extraPools = [ "root" ];
        };
      };

      swapDevices = [ ];

      networking = {
        useDHCP = lib.mkDefault true;
        hostId = "bda049b5";
        hostName = "hemmahos";
      };

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
