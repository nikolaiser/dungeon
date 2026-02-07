{
  dungeon.desktop = {
    homeManager = {
      programs = {
        gpg = {
          enable = true;
          scdaemonSettings = {
            reader-port = "Yubico Yubi";
            disable-ccid = true;
          };
        };
        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks."*".addKeysToAgent = "yes";
        };
      };
      services.gpg-agent.enable = true;
    };

    includes = [
      (
        { host, ... }:
        {
          homeManager =
            { pkgs, ... }:
            {
              services.gpg-agent.pinentry.package =
                if host.class == "darwin" then pkgs.pinentry_mac else pkgs.pinentry-qt;
            };
        }
      )
    ];
  };
}
