{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs = {
    alacritty.enable = true;
    # TODO: Do it properly
    fish.interactiveShellInit = # fish
      ''
        if status is-interactive
         and not set -q TMUX
          exec tmux new-session -A -s main
        end

        set --global --export HOMEBREW_PREFIX "/opt/homebrew";
        set --global --export HOMEBREW_CELLAR "/opt/homebrew/Cellar";
        set --global --export HOMEBREW_REPOSITORY "/opt/homebrew";
        fish_add_path --global --move --path "/opt/homebrew/bin" "/opt/homebrew/sbin";
        if test -n "$MANPATH[1]"; set --global --export MANPATH \'\' $MANPATH; end;
        if not contains "/opt/homebrew/share/info" $INFOPATH; set --global --export INFOPATH "/opt/homebrew/share/info" $INFOPATH; end
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
