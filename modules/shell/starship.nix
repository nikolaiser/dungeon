{

  flake-file.inputs.jj-starship = {
    url = "github:dmmulroy/jj-starship";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  dungeon.shell.homeManager =
    { inputs', lib, ... }:
    {
      programs.starship =
        let
          jjStarshipBin = lib.getExe inputs'.jj-starship.packages.default;
        in
        {
          enable = true;
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
    };
}
