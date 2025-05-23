{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "workqueue.power_efficient=N"
    "i915.force_probe=46a6"
    # "i915.force_probe=!46a6"
    # "xe.force_probe=46a6"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5d3eb2aa-5171-49cf-a65a-203141cce28e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F352-2029";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/b03f73cc-dc76-4682-91ee-a134b2d5329f"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwp0s20f0u2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-uuid/aedd0d6e-3c63-4a38-927f-8f67119eee78";
    preLVM = true;
    allowDiscards = true;
  };

  hardware.cpu.x86.msr = {
    enable = true;
    settings.allow-writes = "on";
  };

  services.tlp = {
    enable = true;
    settings = {

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 900;
      INTEL_GPU_MAX_FREQ_ON_AC = 1400;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1400;

      CPU_MIN_PERF_ON_AC = 50;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 50;
      CPU_MAX_PERF_ON_BAT = 100;

    };
  };

  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_bpfland";
  # };

  services.hardware.bolt.enable = true;
}
