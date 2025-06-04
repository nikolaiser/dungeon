{ lib, pkgs, ... }:

{

  boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];
  boot.extraModprobeConfig = ''
    options brcmfmac feature_disable=0x82000
  '';
  hardware = {
    pulseaudio.enable = true;
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      enable = true;
    };

    enableRedistributableFirmware = true;
  };

  virtualisation.docker.enable = lib.mkForce false;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Speeds up builds by a lot
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };
  programs.command-not-found.enable = false;

  networking = {
    useDHCP = false;
    interfaces = {
      eth0.useDHCP = true;
      wlan0.useDHCP = true;
    };

    wireless.enable = true;
  };
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;

    networks = {
      "10-eth0" = {
        matchConfig.Name = "eth0";
        networkConfig.DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
      "10-wlan0" = {
        matchConfig.Name = "wlan0";
        networkConfig.DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  services.logind.extraConfig = ''
    HandlePowerKey = ignore
  '';
}
