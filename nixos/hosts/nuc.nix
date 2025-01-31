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
    "mlx4_en" # Add mlx4_en to load Mellanox driver early
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
    "netconsole"
  ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [
    "i2c_i801"
    "snd_hda_intel"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };

  boot.kernelParams = [
    # "intel_pstate=active"
    # "intel_pstate=disable"
    # "intel_pstate=passive"
    # "pcie_aspm=force"
    # https://community.intel.com/t5/Processors/Frequent-crashes-on-i5-11500/td-p/1280709?profile.language=ja
    # "processor.max_cstate=0"
    # "intel_idle.max_cstate=0"
    # "idle=poll"
    "irqpoll" # Reassign unhandled IRQs
    "pci=noacpi" # Disable ACPI for PCI routing
    "acpi_enforce_resources=lax" # Relax ACPI resource conflicts

  ];

  # powerManagement.cpuFreqGovernor = "performance";

  boot.postBootCommands = ''
    echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
  '';

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
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  services.journald.extraConfig = ''
    ForwardToSyslog=yes
  '';

  services.rsyslogd = {
    enable = true;
    extraConfig = ''
      # Set the hostname explicitly
      $PreserveFQDN on
      $LocalHostName ${config.networking.hostName}

      *.* @10.10.163.211:514
    '';
  };

  systemd.services.syslog.after = [ "network-online.target" ];

  # systemd service to initialize netconsole after network is ready
  systemd.services.netconsole = {
    description = "Netconsole Setup";
    after = [ "network-online.target" ]; # Ensure enp1s0 is ready
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        let
          startNetconsole = pkgs.writeShellScriptBin "startNetconsole" ''
            ${pkgs.util-linux}/bin/dmesg -n 8
            ${pkgs.kmod}/bin/modprobe -r netconsole || true
            ${pkgs.kmod}/bin/modprobe netconsole netconsole=@/enp1s0,6666@10.10.163.211/
          '';
        in
        "${startNetconsole}/bin/startNetconsole";
      RemainAfterExit = true;
    };
  };

  nodeExporter.enable = true;

}
