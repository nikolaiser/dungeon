{ config, ... }:
{
  networking.networkmanager.enable = true;
  users.users."${config.shared.username}".extraGroups = [ "networkmanager" ];

}
