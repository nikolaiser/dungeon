{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    raycast
  ];

  system.defaults = {
    dock.autohide = true;
    NSGlobalDomain.AppleFontSmoothing = 0;
  };

  environment.variables = {
    JAVA_HOME = "${pkgs.temurin-bin.home}";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
    DOCKER_HOST = "unix:///Users/nikolai.sergeev/.config/colima/default/docker.sock";
    TERM = "ghostty";
  };

  system.defaults = {
    spaces.spans-displays = true;
  };
}
