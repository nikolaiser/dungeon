{
  den,
  dungeon,
  inputs,
  ...
}:
let
  commonConfig =
    { host, ... }:
    {
      ${host.class} =
        { pkgs, ... }:
        let
          iosevka = pkgs.nerd-fonts.iosevka-term;
        in

        {

          imports = [
            inputs.stylix."${host.class}Modules".default
          ];

          fonts.packages = [ iosevka ];

          stylix = {
            enable = true;
            enableReleaseChecks = false;
            image = ./wallpapers/wallhaven-3looxy_3840x2160.png;

            targets.fish.enable = false;

            base16Scheme = ./themes/carbonfox.yaml;

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
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };

            };

          };
        };

      homeManager = {
        stylix.enableReleaseChecks = false;
      };
    };
in
{

  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  dungeon.stylix = den.lib.parametric {
    includes = [
      dungeon.stylix._.specific
      commonConfig
    ];
  };

}
