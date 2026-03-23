{
  dungeon.desktop =
    { host, ... }:
    {
      includes = [
        (
          { host, ... }:
          if host.class == "darwin" then
            { }
          else
            {

              homeManager =
                { pkgs, ... }:
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
                    discord
                  ];

                  services.mpris-proxy.enable = true;

                  systemd.user.targets.tray = {
                    Unit = {
                      Description = "Home Manager System Tray";
                      Requires = [ "graphical-session-pre.target" ];
                    };
                  };
                };
            }
        )
      ];
    };
}
