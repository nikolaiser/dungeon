{ pkgs, ... }:

let
  update-containers = pkgs.writeShellScriptBin "update-containers" ''
    	SUDO=""
    	if [[ $(id -u) -ne 0 ]]; then
    		SUDO="sudo"
    	fi

        images=$($SUDO ${pkgs.podman}/bin/podman ps -a --format="{{.Image}}" | sort -u)

        for image in $images
        do
          $SUDO ${pkgs.podman}/bin/podman pull $image
        done
  '';
in

{
  environment.systemPackages = [ update-containers ];

  systemd = {
    timers = {
      updatecontainers = {
        timerConfig = {
          Unit = "updatecontainers.service";
          OnCalendar = "Mon 02:00";
        };
        wantedBy = [ "timers.target" ];
      };
      restartcontainers = {
        timerConfig = {
          Unit = "restartcontainers.service";
          OnCalendar = "Mon 03:00";
        };
        wantedBy = [ "timers.target" ];
      };
    };

    services = {
      updatecontainers = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${update-containers}/bin/update-containers";
        };
      };
      restartcontainers = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.podman}/bin/podman restart --all";
        };
      };
    };
  };

}
