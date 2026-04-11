{
  den.aspects.hemmahos-nikolaiser.nixos =

    {
      lib,
      config,
      pkgs,
      ...
    }:
    {

      # TODO: Remove
      security.sudo.extraRules = [
        {
          users = [ "nikolaiser" ];
          commands = [
            {
              command = "${pkgs.iproute2}/bin/ip";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];

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
        # useDHCP = lib.mkDefault true;
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

      programs.virt-manager.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        onBoot = "ignore";
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [
        virt-viewer
      ];
      users.users.nikolaiser.extraGroups = [
        "libvirtd"
        "kvm"
      ];
      boot.extraModprobeConfig = ''
        options kvm_amd nested=1
      '';
      networking.bridges.br0.interfaces = [ "enp21s0" ];
      networking.interfaces.br0.ipv4 = {
        addresses = [
          {
            address = "10.10.163.212";
            prefixLength = 16;
          }
        ];
        routes = [
          {
            address = "0.0.0.0";
            prefixLength = 0;
            via = "10.10.0.1";
          }
        ];
      };

      networking.defaultGateway = {
        address = "10.10.0.1";
        interface = "br0";
      };
      networking.nameservers = [
        "10.10.0.1"
      ];

    };
}
