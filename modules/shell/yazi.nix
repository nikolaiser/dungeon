{
  dungeon.shell.homeManager =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        plugins = {
          git = pkgs.yaziPlugins.git;
        };
        initLua = ''
          require("git"):setup()
        '';
        settings = {
          plugin.prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];

        };

      };
    };
}
