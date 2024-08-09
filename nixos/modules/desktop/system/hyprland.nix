{ pkgs, inputs, config, ... }:

{
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

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

  programs.hyprland.enable = true;
  security.polkit.enable = true;
}
