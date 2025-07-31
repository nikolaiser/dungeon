{
  pkgs,
  ...
}:
let
  iosevka = pkgs.nerd-fonts.iosevka-term;
in

{

  fonts.packages = [ iosevka ];

  stylix = {
    enable = true;
    image = ../../linuxDesktop/home/wallpapers/wallhaven-3looxy_3840x2160.png;

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

  };
}
