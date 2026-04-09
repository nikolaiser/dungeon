{
  dungeon.desktop._.colima = {
    homeManager = {
      services.colima = {
        enable = true;
        profiles.default = {
          isActive = true;
          isService = true;
          setDockerHost = true;
          settings = {
            arch = "x86_64";
            memory = 4;
            network.address = true;
          };
        };
      };
    };
  };
}
