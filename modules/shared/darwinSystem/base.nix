{
  pkgs,
  config,
  inputs,
  ...
}:
let
  stateVersion = "25.11";
  darwinStateVersion = 6;
in
{
  time.timeZone = "Europe/Berlin";

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = darwinStateVersion;
  home-manager.users.${config.shared.username}.home.stateVersion = stateVersion;

  # Because of determinate
  nix.enable = false;

}
