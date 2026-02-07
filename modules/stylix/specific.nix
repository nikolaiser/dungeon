{ inputs, ... }:
{
  dungeon.stylix._.specific =
    # {
    #   user,
    #   host,
    #   ...
    # }:
    {

      nixos =
        { pkgs, ... }:
        {

          stylix = {
            fonts.sizes = {
              desktop = 16;
              applications = 14;
            };

            cursor = {
              package = pkgs.catppuccin-cursors.macchiatoLavender;
              name = "catppuccin-macchiato-lavender-cursors";
              size = 24;
            };
          };
        };

      darwin = {

        stylix.fonts.sizes = {
          desktop = 24;
          applications = 18;
        };
      };

    };
}
