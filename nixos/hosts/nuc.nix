# Do not modify this file!  It was generated by ‘nixos-generate-config’                                               
# and may be overwritten by future invocations.  Please make changes                                                  
# to /etc/nixos/configuration.nix instead.                                                                            
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "ahci"
    "usbhid"
    "rtsx_pci_sdmmc"
    "iscsi_tcp"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "br_netfilter"
    "ip_conntrack"
    "ip_vs"
    "ip_vs_rr"
    "ip_vs_wrr"
    "ip_vs_sh"
    "overlay"
    "iptable_raw"
    "xt_socket"
    "iscsi_tcp"
  ];
  boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };

  services.openiscsi = {
    discoverPortal = "10.10.163.211";
    enableAutoLoginOut = true;
  };

  boot.supportedFilesystems = [ "nfs" ];

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };

    "/mnt/iscsi" = {
      device = "/dev/disk/by-path/ip-10.10.163.211:3260-iscsi-iqn.2000-05.edu.example.iscsi:${config.networking.hostName}-target-lun-0";
      fsType = "ext4";
      options = [
        "_netdev"
        "nofail"
      ];
    };

    "/var/lib/rancher/k3s" = {
      device = "/mnt/iscsi/var-lib-rancher-k3s";
      depends = [
        "/mnt/iscsi"
      ];
      fsType = "none";
      options = [
        "bind"
        "_netdev"
        "nofail"
      ];
    };
    "/var/lib/kubelet" = {
      device = "/mnt/iscsi/var-lib-kubelet";
      depends = [
        "/mnt/iscsi"
      ];
      fsType = "none";
      options = [
        "bind"
        "_netdev"
        "nofail"
      ];
    };
    "/etc/rancher" = {
      device = "/mnt/iscsi/etc-rancher";
      depends = [
        "/mnt/iscsi"
      ];
      fsType = "none";
      options = [
        "bind"
        "_netdev"
        "nofail"
      ];
    };

  };

  swapDevices = [ ];

  networking = {
    useNetworkd = true;
    useDHCP = lib.mkDefault false;

    defaultGateway = {
      address = "10.10.0.1";
      interface = "enp1s0";
    };

    firewall.enable = true;

    nameservers = [ "10.10.0.1" ];
  };

  systemd.network = {
    enable = true;
    networks."40-enp1s0".networkConfig.MulticastDNS = true;
  };

  environment.systemPackages = with pkgs; [
    ethtool
    gitMinimal
    iproute2
    iptables
    k3s
    openssh
    socat
    thin-provisioning-tools
    utillinux
    bash
    curl
    util-linux
    gnugrep
    gawk
    nfs-utils
    ethtool
    conntrack-tools
    cri-tools
    kubectl
    kubernetes
  ];

  # no bootloader for netboot 
  system.build.installBootLoader = lib.mkDefault "${pkgs.coreutils}/bin/true";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
