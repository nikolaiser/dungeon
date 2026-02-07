{
  dungeon.shell.homeManager.programs = {

    direnv = {
      enable = true;
      config = {
        global.hide_env_diff = true;
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
    };

  };
}
