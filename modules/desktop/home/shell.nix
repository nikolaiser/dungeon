{
  lib,
  pkgs,
  config,
  system,
  ...
}:
{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        scrolling.multiplier = 1;
      };
    };
    # TODO: Do it properly
    fish.interactiveShellInit = # fish
      let
        colimaInit = ''
          set colima_cache_file ~/.cache/colima_address
          set cache_age_minutes 60

          if not test -f $colima_cache_file
              mkdir -p (dirname $colima_cache_file)
              colima ls -j | jq -r '.address' > $colima_cache_file 2>/dev/null
          else
              # Check if file is older than 60 minutes  
              set file_age (math (date +%s) - (stat -f %m $colima_cache_file))
              if test $file_age -gt (math $cache_age_minutes \* 60)
                  colima ls -j | jq -r '.address' > $colima_cache_file 2>/dev/null
              end
          end
          set -x TESTCONTAINERS_HOST_OVERRIDE (cat $colima_cache_file 2>/dev/null)

        '';

        brewInit = ''
          brew shellenv 2>/dev/null | source || true
        '';

        macosInit = ''
          ${colimaInit}

          ${brewInit}
        '';

      in
      ''
        if status is-interactive
         and not set -q TMUX
          exec tmux new-session -A -s main
        end
      ''
      + (if system == "aarch64-darwin" then macosInit else "");

    starship.settings = lib.mkForce {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"

        "$line_break"
        "$character"
      ];
      git_branch = {
        only_attached = true;
      };
    };
  };

  home.packages = with pkgs; [ tmux-sessionizer ];

  xdg.configFile."tms/config.toml" = {
    text = "search_paths = ['${config.home.homeDirectory}/Documents', '${config.home.homeDirectory}/.config/nvim', '${config.home.homeDirectory}/.config/dungeon' ]";
  };

}
