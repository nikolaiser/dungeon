{
  pkgs,
  lib,
  system,
  ...
}:

let
  browser = "librewolf.desktop";

  defaultApplications = {
    "default-web-browser" = browser;
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/pdf" = browser;
    "image/jpg" = browser;
    "image/png" = browser;
  };
in
{

  home.packages = with pkgs; [
    ungoogled-chromium
    nautilus
    pavucontrol
    vial
    via
    playerctl
    # libsForQt5.plasma-pa
    drawing
    libreoffice-qt6-fresh
    marp-cli
    telegram-desktop
  ];

  services.mpris-proxy.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = defaultApplications;
    associations.added = defaultApplications;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
