{
  dungeon.shell.homeManager.programs = {

    direnv = {
      enable = true;
      # Direnv package provides vendor_conf.d/direnv.fish; disable HM's copy to avoid double-init
      enableFishIntegration = false;
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
