{ config, ... }:

{

  users.users.${config.shared.username}.extraGroups = [
    "networkmanager"
    "dialout"
    "gamemode"
  ];

}
