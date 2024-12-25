{
  pkgs,
  config,
  inputs,
  ...
}:
let
  stateVersion = "24.11";
in
{
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Berlin";
  };

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    git
    powertop
  ];

  services.fwupd.enable = true;

  hardware.enableAllFirmware = true;

  virtualisation.docker.enable = true;

  system.stateVersion = stateVersion;
  home-manager.users.${config.username}.home.stateVersion = stateVersion;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix-path = "nixpkgs=flake:nixpkgs";
    };
  };

  networking.firewall.enable = true;

  system.switch.enableNg = true;
  powerManagement.powertop.enable = true;

}
