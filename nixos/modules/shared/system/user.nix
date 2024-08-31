{ config, pkgs, ... }:

{

  users.users.${config.username} = {
    isNormalUser = true;
    home = "/home/${config.username}";
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
  };

}
