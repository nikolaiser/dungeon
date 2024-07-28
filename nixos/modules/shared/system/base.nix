{ pkgs, ... }:

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

  system.stateVersion = "24.05";


  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
