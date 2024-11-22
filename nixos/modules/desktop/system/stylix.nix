{ pkgs, ... }:
let
  nerdfonts = (
    pkgs.nerdfonts.override {
      fonts = [
        "Iosevka"
      ];
    }
  );
in

{

  fonts.packages = [ nerdfonts ];

  stylix = {
    enable = true;
    image = ../home/wallpapers/wallhaven-gpvw7q_3840x2160.png;

    targets.fish.enable = false;

    base16Scheme = ./theme/duskfox.yaml;

    polarity = "dark";

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override { variant = "Etoile"; };
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override { variant = "Aile"; };
        name = "Iosevka Aile";
      };

      monospace = {
        package = nerdfonts;
        name = "Iosevka Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = 16;
        applications = 14;
      };

    };

  };
}
