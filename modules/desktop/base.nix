{
  dungeon.desktop = {

    includes = [ ];

    nixos = {

      services.printing.enable = true;
      qt.enable = true;
      # stylixConfig.enable = true;

      services.displayManager.ly.enable = true;
    };

    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          raycast
          colima
          docker
          mos
        ];

        system.defaults = {
          dock.autohide = true;
          NSGlobalDomain.AppleFontSmoothing = 0;
          NSGlobalDomain."com.apple.swipescrolldirection" = true;
        };

        environment.variables = {
          JAVA_HOME = "${pkgs.temurin-bin.home}";
          TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
          TERM = "ghostty";
        };

        system.defaults = {
          spaces.spans-displays = false;
        };
      };
  };
}
