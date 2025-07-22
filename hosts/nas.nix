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
  ];

  powerManagement.cpuFreqGovernor = "powersave";

  fileSystems = {

    "/" = {
      device = "nvme/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "nvme/home";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/nix" = {
      device = "nvme/nix";
      fsType = "zfs";
    };
    "/nvmeStorage" = {
      device = "nvme/nvmeStorage";
      fsType = "zfs";
    };
    "/home/ops/.local/share/atuin" = {
      device = "/dev/zvol/nvme/atuin";
      fsType = "ext4";
    };
    "/boot1" = {
      device = "/dev/disk/by-uuid/3C2A-02AE";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/boot2" = {
      device = "/dev/disk/by-uuid/3C5F-136A";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

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

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

}
