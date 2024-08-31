{ config, ... }:

{

  users.users.${config.username}.extraGroups = [
    "networkmanager"
    "dialout"
    "gamemode"
  ];

}
