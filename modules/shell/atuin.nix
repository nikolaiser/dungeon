{
  dungeon.shell.homeManager =
    { osConfig, ... }:
    {
      programs.atuin = {

        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        settings = {
          inline_height = "5";
          sync_address = "https://atuin.${osConfig.nas.baseDomain.public}";
        };
      };
    };
}
