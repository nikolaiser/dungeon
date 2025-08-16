{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    raycast
    colima
    docker
  ];

  system.defaults.dock.autohide = true;

  homebrew = {

    enable = true;
    taps = [
      {
        name = "getyourguide/dev";
        clone_target = "git@github.com:getyourguide/dev";
      }
    ];
    brews = [
      "dev-bundle"
    ];

  };

  environment.variables.JAVA_HOME = "${pkgs.temurin-bin.home}";
}
