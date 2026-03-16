{
  dungeon.shell.homeManager =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.fish.interactiveShellInit = ''
        if status is-interactive
         and not set -q TMUX
          exec tmux new-session -A -s main
        end
      '';
      programs.tmux = {

        enable = true;
        clock24 = true;
        mouse = true;
        terminal = "tmux-256color";
        historyLimit = 50000;
        escapeTime = 10;
        prefix = "C-s";

        extraConfig = # tmux
          ''
            bind-key m display-popup -E "${lib.getExe pkgs.tmux-sessionizer}"

            set -ag terminal-overrides ",xterm-ghostty:Tc"
            set -g default-terminal "tmux-256color"

            set -g allow-passthrough on
            set -g visual-activity off
            set-option -g focus-events on


            set -g extended-keys on
            set -as terminal-features 'xterm*:extkeys'

            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM

            set-option -g status-position top
            set -g status-left-length 20

            unbind -T copy-mode-vi  MouseDragEnd1Pane
            bind   -T copy-mode-vi  MouseDragEnd1Pane send -X copy-selection-no-clear

            unbind -T copy-mode     MouseDragEnd1Pane
            bind   -T copy-mode     MouseDragEnd1Pane send -X copy-selection-no-clear

            is_vim_or_hx="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|l?n?hx?x?|fzf|nvim-wrapped)(diff)?$'"
            bind-key -n C-Left if-shell "$is_vim_or_hx" "send-keys C-Left" "select-pane -L"
            bind-key -n C-Down if-shell "$is_vim_or_hx" "send-keys C-Down" "select-pane -D"
            bind-key -n C-Up if-shell "$is_vim_or_hx" "send-keys C-Up" "select-pane -U"
            bind-key -n C-Right if-shell "$is_vim_or_hx" "send-keys C-Right" "select-pane -R"
          '';
      };

      home.packages = with pkgs; [ tmux-sessionizer ];

      xdg.configFile."tms/config.toml" = {
        text = ''
          [[search_dirs]]
          path = "${config.home.homeDirectory}/Documents"
          depth = 2

          [[search_dirs]]
          path = "${config.home.homeDirectory}/.config/dungeon" 
          depth = 1
        '';
      };
    };
}
