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

  root1Id = "/dev/disk/by-id/ata-INTENSO_SSD_1642311001016696";
  root2Id = "/dev/disk/by-id/ata-INTENSO_SSD_1642311001016674";
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
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  disko.devices = {
    disk = {
      root1 = {
        type = "disk";
        device = root1Id;
        content = rootDriveContent "/boot1";
      };
      root2 = {
        type = "disk";
        device = root2Id;
        content = rootDriveContent "/boot2";
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
    };
  };

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    devices = lib.mkForce [ ];
    mirroredBoots = [
      {
        devices = ["nodev"];
        path = "/boot1";
        efiSysMountPoint = "/boot1";
      }
      {
        devices = ["nodev"];
        path = "/boot2";
        efiSysMountPoint = "/boot2";
      }
    ];
  };

  boot.loader.efi.canTouchEfiVariables = true;

}
