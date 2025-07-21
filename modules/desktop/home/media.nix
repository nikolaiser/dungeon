{ pkgs, lib, ... }:

let
  browser = "firefox.desktop";

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
    nautilus
    pavucontrol
    vial
    via
    playerctl
    libsForQt5.plasma-pa
    drawing
    libreoffice-qt6-fresh
    marp-cli
  ];

  services.mpris-proxy.enable = true;

  xdg.desktopEntries.firefoxWork = {
    exec = "firefox -P work";
    genericName = "Firefox (work)";
    name = "Firefox (work)";
    type = "Application";
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = defaultApplications;
    associations.added = defaultApplications;
  };
}
