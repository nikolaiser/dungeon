{

  dungeon.desktop._.sway.nixos =
    {
      pkgs,
      ...
    }:

    {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
      ];

      services = {
        gvfs.enable = true;
        tumbler.enable = true;
      };

      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        xwayland.enable = true;
      };

      security.polkit.enable = true;
    };
}
