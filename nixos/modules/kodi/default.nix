{ config, lib, pkgs, ... }:


let
  libcec = pkgs.libcec.override { withLibraspberrypi = true; };
  kodi = pkgs.kodi-wayland.withPackages (p: with p; [ youtube ]);

in
{
  options.kodi.enable = lib.mkEnableOption "Enable kodi support";

  config = lib.mkIf config.kodi.enable {
    environment.systemPackages = [
      libcec
      pkgs.libraspberrypi
      pkgs.raspberrypi-eeprom
    ];

    users.extraUsers.kodi = {
      isNormalUser = true;
      extraGroups = [ "video" ];
    };


    services.cage = {
      enable = true;
      user = "kodi";
      program = "${kodi}/bin/kodi-standalone";
    };

    services.udev.extraRules = ''
      # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
      KERNEL == "vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
    '';

    # optional: attach a persisted cec-client to `/run/cec.fifo`, to avoid the CEC ~1s startup delay per command
    # scan for devices: `echo 'scan' > /run/cec.fifo ; journalctl -u cec-client.service`
    # set pi as active source: `echo 'as' > /run/cec.fifo`
    systemd.sockets."cec-client" = {
      after = [ "dev-vchiq.device" ];
      bindsTo = [ "dev-vchiq.device" ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenFIFO = "/run/cec.fifo";
        SocketGroup = "video";
        SocketMode = "0660";
      };
    };
    systemd.services."cec-client" = {
      after = [ "dev-vchiq.device" ];
      bindsTo = [ "dev-vchiq.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${libcec}/bin/cec-client -d 1'';
        ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
        StandardInput = "socket";
        StandardOutput = "journal";
        Restart = "no";
      };
    };

    home-manager = {
      users."kodi".imports = [ ./home ];
      backupFileExtension = "backup";
    };

  };

}


