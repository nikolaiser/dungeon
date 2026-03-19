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
          "usbcore.authorized_default=0"
          "usbcore.initial_descriptor_timeout=500"
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

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", ATTR{authorized}="1"
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="3-7", ATTR{authorized}="0"
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="3-7.*", ATTR{authorized}="0"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{authorized}!="1", ATTR{authorized}="1"
      '';

      boot.initrd.services.udev.rules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", ATTR{authorized}="1"
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="3-7", ATTR{authorized}="0"
        ACTION=="add", SUBSYSTEM=="usb", KERNEL=="3-7.*", ATTR{authorized}="0"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{authorized}!="1", ATTR{authorized}="1"
      '';
    };
}
