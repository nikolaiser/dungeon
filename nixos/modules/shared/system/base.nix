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
    hardwareClockInLocalTime = false;
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
  home-manager.users.${config.shared.username}.home.stateVersion = stateVersion;

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

  nix.settings = {
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

}
