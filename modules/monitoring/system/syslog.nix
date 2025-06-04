{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [ netcat ];

  systemd.services.netconsole-receiver = {
    description = "Netconsole Log Receiver";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat -u UDP-LISTEN:6666,fork -";
      Restart = "always";
      User = "root";
    };
  };

  services = {
    rsyslogd = {
      enable = true;
      extraConfig = ''
        # Listen for logs on UDP port 514
        $ModLoad imudp
        $UDPServerRun 514

        # Listen for logs on TCP port 514
        $ModLoad imtcp
        $InputTCPServerRun 514

        # Store remote logs in a separate directory
        $template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
        *.* ?RemoteLogs
        & ~  # Stop further processing for remote logs
      '';
    };
  };

  # Ensure log directory exists
  systemd.tmpfiles.rules = [
    "d /var/log/remote 0755 root root -"
  ];

  networking.firewall = {
    allowedTCPPorts = [ 514 ];
    allowedUDPPorts = [
      514
      6666
    ];
  };

}
