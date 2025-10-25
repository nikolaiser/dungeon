{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.zfs.extraPools = [ "root" ];

  boot.kernelParams = [
    "amd_pstate=guided"
    "pcie_aspm=force"
  ];

  fileSystems."/" = {
    device = "root/root";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "root/var";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "root/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "root/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F10A-6075";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/home/nikolaiser/.local/share/atuin" = {
    device = "/dev/zvol/root/atuin";
    fsType = "ext4";
  };

  swapDevices = [ ];

  # networking = {
  #
  #   nameservers = [
  #     "10.10.0.1"
  #   ];
  #
  #   interfaces.enp24s0.ipv4 = {
  #     addresses = [
  #       {
  #         address = "10.10.163.212";
  #         prefixLength = 16;
  #       }
  #     ];
  #     routes = [
  #       {
  #         address = "0.0.0.0"; # Default route
  #         prefixLength = 0;
  #         via = "10.10.0.1";
  #       }
  #     ];
  #   };
  #
  #   # interfaces.enp8s0.ipv4 = {
  #   #   addresses = [
  #   #     {
  #   #       address = "10.2.0.2";
  #   #       prefixLength = 8;
  #   #     }
  #   #   ];
  #   #   routes = [
  #   #     {
  #   #       address = "10.2.0.5"; # Default route
  #   #       prefixLength = 32;
  #   #       via = "10.2.0.5";
  #   #     }
  #   #   ];
  #   #
  #   # };``
  #   defaultGateway = {
  #     address = "10.10.0.1";
  #     interface = "enp24s0";
  #   };
  #
  # };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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
