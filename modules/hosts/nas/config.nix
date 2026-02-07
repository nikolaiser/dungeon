{
  den.aspects.nas-ops.nixos =

    { lib, pkgs, ... }:
    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "mpt3sas"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      boot.initrd.kernelModules = [ ];
      boot.postBootCommands = ''
        ${pkgs.zfs}/bin/zpool import hdd
        ${pkgs.zfs}/bin/zfs load-key -a
        ${pkgs.zfs}/bin/zfs mount -a
      '';
      boot.kernelModules = [
        "kvm-amd"
        "vfio"
        "vfio_pci"
        "ip_tables"
        "iptable_filter"
        "iptable_nat"
        "ip6_tables"
        "ip6table_filter"
        "ip6table_nat"
        "x_tables"
        "xt_conntrack"
        "nf_conntrack"
        "nf_nat"
      ];
      boot.extraModulePackages = [ ];
      boot.supportedFilesystems = {
        zfs = lib.mkForce true;
      };
      boot.zfs.devNodes = "/dev/disk/by-id";
      boot.kernelParams = [
        "amd_pstate=guided"
        "pcie_aspm=force"
        "zfs_force=1"
        "zfs.zfs_arc_max=34359738368"
      ];

      powerManagement.cpuFreqGovernor = "powersave";

      boot.loader.grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        devices = lib.mkForce [ ];
        mirroredBoots = [
          {
            devices = [ "nodev" ];
            path = "/boot1";
            efiSysMountPoint = "/boot1";
          }
          {
            devices = [ "nodev" ];
            path = "/boot2";
            efiSysMountPoint = "/boot2";
          }
        ];
      };

      networking.firewall.allowedTCPPorts = [ 5201 ];

      boot.loader.efi.canTouchEfiVariables = true;

      networking = {
        hostId = "d4cf0337";
        hostName = "nas";
      };
    };
}
