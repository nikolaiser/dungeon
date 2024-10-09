{ pkgs, config, ... }:
let
  stateVersion = "24.11";
in
{
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Berlin";
  };

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [ git ];

  services.fwupd.enable = true;

  hardware.enableAllFirmware = true;

  virtualisation.docker.enable = true;

  system.stateVersion = stateVersion;
  home-manager.users.${config.username}.home.stateVersion = stateVersion;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking.firewall.enable = true;

  system.switch.enableNg = true;

}
