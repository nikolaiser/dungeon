{
  dungeon.shell.homeManager =

    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      zoxideSearchPaths = [
        "${config.home.homeDirectory}/Documents"
        "${config.home.homeDirectory}/.config/dungeon"
      ];
      zoxideMaxDepth = 3;

      zoxidePopulateScript = pkgs.writeShellScriptBin "zoxide-populate" (
        lib.concatMapStringsSep "\n" (path: ''
          ${lib.getExe pkgs.fd} -H -t d '^\\.git$' ${path} --max-depth ${toString zoxideMaxDepth} -x zoxide add {//}
        '') zoxideSearchPaths
      );

      cachedZoxideInit = pkgs.runCommand "zoxide-fish-init" { } ''
        HOME=/tmp ${lib.getExe pkgs.zoxide} init fish > $out
      '';
    in
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = false;
      };

      programs.fish = {
        shellInit = ''
          # Prepopulate zoxide with git repos (background)
          ${lib.getExe zoxidePopulateScript} >/dev/null 2>&1 &
          disown
        '';

        interactiveShellInit = ''
          source ${cachedZoxideInit}
        '';
      };
    };
}
