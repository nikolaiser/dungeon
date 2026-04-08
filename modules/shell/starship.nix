{

  flake-file.inputs.jj-starship = {
    url = "github:dmmulroy/jj-starship";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  dungeon.shell.homeManager =
    {
      inputs',
      lib,
      pkgs,
      ...
    }:
    let
      jjStarshipBin = lib.getExe inputs'.jj-starship.packages.default;
      cachedStarshipInit = pkgs.runCommand "starship-fish-init" { } ''
        HOME=/tmp ${lib.getExe pkgs.starship} init fish --print-full-init > $out
      '';
    in
    {
      programs.starship = {
        enable = true;
        enableFishIntegration = false;
        settings = {
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$custom.jj"
            "$nix_shell"
            "$cmd_duration"

            "$line_break"
            "$character"
          ];
          git_branch = {
            only_attached = true;
            disabled = true;
          };
          git_status = {
            disabled = true;
          };

          custom.jj = {
            when = "${jjStarshipBin} detect";
            shell = [ "${jjStarshipBin}" ];
            format = "$output";
          };
        };
      };

      programs.fish.interactiveShellInit = ''
        if test "$TERM" != dumb
          source ${cachedStarshipInit}
        end
      '';
    };
}
