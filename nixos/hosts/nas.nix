{ lib, pkgs, ... }:

let
  rootDriveContent = bootMountpoint: {
    type = "gpt";
    partitions = {
      ESP = {
        size = "1G";
        type = "EF00";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = bootMountpoint;
          mountOptions = [ "nofail" ];
        };
      };
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "root";
        };
      };
    };

  };

  fastStorageDriveContent = {
    type = "gpt";
    partitions = {
      zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "nvme";
        };
      };
    };
  };

in
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
  boot.initrd.postMountCommands = "sleep 5; zpool import -a; zfs load-key -a";
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = {
    zfs = lib.mkForce true;
  };
  boot.kernelParams = [
    "amd_pstate=guided"
    "pcie_aspm=force"
  ];

  powerManagement.cpuFreqGovernor = "powersave";

  disko.devices = {
    disk = {
      root1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-INTENSO_SSD_1642311001016696";
        content = rootDriveContent "/boot1";
      };
      root2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-INTENSO_SSD_1642311001016674";
        content = rootDriveContent "/boot2";
      };
      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G3_SSD_YDBKF1HXZ0EA";
        content = fastStorageDriveContent;
      };
      nvme2 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G3_SSD_YDBKF184Z0EA";
        content = fastStorageDriveContent;
      };
      nvme3 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G3_SSD_YDBKF1H9Z0EA";
        content = fastStorageDriveContent;
      };
    };
    zpool = {
      root = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
        };

        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
        };
      };
      # nvme = {
      #   type = "zpool";
      #   mode = {
      #     topology = {
      #       type = "topology";
      #       vdev = [
      #         {
      #           mode = "raidz1";
      #           members = [
      #             "nvme1"
      #             "nvme2"
      #             "nvme3"
      #           ];
      #         }
      #       ];
      #
      #     };
      #     options = {
      #       acltype = "posixacl";
      #       atime = "off";
      #       compression = "lz4";
      #       mountpoint = "none";
      #       xattr = "sa";
      #       "com.sun:auto-snapshot" = "true";
      #       autoexpand = "on";
      #       ashift = "12";
      #       "feature@async_destroy"="enabled";
      #       "feature@empty_bpobj"="enabled";
      #       "feature@lz4_compress"="enabled";
      #     };
      #     datasets = {
      #       "local" = {
      #         type = "zfs_fs";
      #         options.mountpoint = "none";
      #       };
      #       "local/nvmeStorage" = {
      #         type = "zfs_fs";
      #         mountpoint = "/nvmeStorage";
      #       };
      #     };
      #   };
      # };
    };
  };

  fileSystems."/nvmeStorage" = {
    device = "nvme/nvmeStorage";
    fsType = "zfs";
  };

  # fileSystems."/hddStorage" = {
  #   device = "hdd/hddStorage";
  #   fsType = "zfs";
  # };

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
