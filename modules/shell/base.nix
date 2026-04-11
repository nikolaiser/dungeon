{
  dungeon.shell = {

    includes = [
      (
        { user, ... }:
        {
          os =
            { pkgs, ... }:
            {
              users.users.${user.userName}.shell = pkgs.fish;
              programs.fish.enable = true;
            };
        }
      )
    ];
    homeManager =
      { pkgs, ... }:
      {
        home = {
          packages = with pkgs; [
            xdg-utils
            fzf
            jq
            ripgrep
            util-linux
            unzip
            age
            fd
          ];

          sessionVariables = {
            EDITOR = "nvim";
          };
        };
        fonts.fontconfig.enable = true;
        xdg.enable = true;
      };

  };
}
