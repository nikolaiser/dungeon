{ config, pkgs, ... }:


{


  users.users.${config.username} = {
    isNormalUser = true;
    home = "/home/${config.username}";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "dialout"
      "gamemode"
    ];
    shell = pkgs.fish;
  };

}
