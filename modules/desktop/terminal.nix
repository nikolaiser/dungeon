let
  packageAspect =
    { host, ... }:
    {
      homeManager =
        { pkgs, ... }:
        {
          programs.ghostty.package = (if host.class == "darwin" then pkgs.ghostty-bin else pkgs.ghostty);
        };
    };
in
{
  dungeon.desktop = {
    includes = [ packageAspect ];
    homeManager = {

      programs = {
        ghostty = {
          enable = true;
          enableFishIntegration = true;
          installBatSyntax = true;
          # clearDefaultKeybinds = true;
          settings = {
            confirm-close-surface = false;
            shell-integration = "fish";
          };
        };
      };
    };
  };
}
