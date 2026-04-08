{
  dungeon.shell.homeManager =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    let
      cachedAtuinInit = pkgs.runCommand "atuin-fish-init" { } ''
        HOME=/tmp ${lib.getExe pkgs.atuin} init fish > $out
      '';
    in
    {
      programs.atuin = {
        enable = true;
        enableFishIntegration = false;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        settings = {
          inline_height = "5";
          sync_address = "https://atuin.${osConfig.nas.baseDomain.public}";
        };
      };

      programs.fish.interactiveShellInit = ''
        source ${cachedAtuinInit}
      '';
    };
}
