{
  dungeon.desktop.homeManager.programs = {
    git = {
      enable = true;

      ignores = [
        ".direnv"
        "bin"
        ".metals"
        "project/metals.sbt"
        "project/project"
        ".bloop"
        ".claude/settings.local.json"
        "docs/plans"
        "docs/patterns"
      ];

      settings = {
        user = {
          email = "mail@nikolaiser.com";
          name = "nikolaiser";
        };

        signing = {
          key = "980B9E9C5686F13A";
          signByDefault = true;
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "mail@nikolaiser.com";
          name = "nikolaiser";
          git = {
            push-bookmark-prefix = "origin";
            auto-track = true;
          };
        };
        ui = {
          diff-editor = [
            "nvim"
            "-c"
            "DiffEditor $left $right $output"
          ];
        };
        remotes.origin.auto-track-bookmarks = "*";
      };
    };
  };
}
