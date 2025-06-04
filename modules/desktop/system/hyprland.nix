{
  pkgs,
  inputs,
  config,
  ...
}:

{
  xdg.portal = {
    enable = true;

    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = "hyprland";
      };
    };
  };

  environment.systemPackages = [
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
  ];

  services = {

    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    displayManager = {
      defaultSession = "hyprland";
    };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  security.polkit.enable = true;
}
