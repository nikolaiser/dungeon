{
  pkgs,
  osConfig ? null,
  ...
}:
let
  iosevka = pkgs.nerd-fonts.iosevka-term;
in

if builtins.isNull osConfig then
  {

    home.packages = [ iosevka ];

    fonts.fontconfig.enable = true;

    stylix = {
      enable = true;
      image = ../../linuxDesktop/home/wallpapers/wallhaven-3looxy_3840x2160.png;

      targets.fish.enable = false;

      base16Scheme = ../../linuxDesktop/system/theme/carbonfox.yaml;

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
          package = iosevka;
          name = "IosevkaTerm Nerd Font";
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

      cursor = {
        package = pkgs.catppuccin-cursors.macchiatoLavender;
        name = "catppuccin-macchiato-lavender-cursors";
        size = 24;
      };

    };
  }
else
  { }
