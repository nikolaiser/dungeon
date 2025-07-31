{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs = {
    alacritty.enable = true;
    fish.interactiveShellInit = # fish
      ''
        if status is-interactive
         and not set -q TMUX
          exec tmux new-session -A -s main
        end
      '';

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
