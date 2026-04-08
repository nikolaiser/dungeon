{
  dungeon.desktop.homeManager =
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
        escapeTime = 0;
        prefix = "C-s";
        aggressiveResize = true;

        extraConfig =
          let
            newNotebook = pkgs.writeShellScriptBin "newNotebook" ''
              read -p "Notebook Name: " value

              if [ -z "$value" ]; then
                value=$(${pkgs.coreutils}/bin/date +"%Y-%m-%d_%H-%M-%S")
              fi

              dir="${config.home.homeDirectory}/Documents/getyourguide/nikolaiser-notebooks/$value"
              session_name="notebook-$value"

              ${pkgs.coreutils}/bin/mkdir -p "$dir"

              ${pkgs.zoxide}/bin/zoxide add "$dir"

              if [ -n "$TMUX" ]; then
                ${pkgs.tmux}/bin/tmux new-session -d -s "$session_name" -c "$dir" "nvim"
                ${pkgs.tmux}/bin/tmux switch-client -t "$session_name"
              else
                ${pkgs.tmux}/bin/tmux new-session -s "$session_name" -c "$dir" "nvim"
              fi
            '';

            zoxideSessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
              if [[ $# -eq 1 ]]; then
                selected="$1"
              else
                selected=$(${pkgs.zoxide}/bin/zoxide query --list | ${pkgs.fzf}/bin/fzf) || exit 130
              fi

              [[ -z "$selected" ]] && exit 130

              selected_name=$(${pkgs.coreutils}/bin/basename "$selected" | ${pkgs.coreutils}/bin/tr . _)
              tmux_running=$(${pkgs.procps}/bin/pgrep tmux)

              if [[ -z "$TMUX" ]] && [[ -z "$tmux_running" ]]; then
                ${pkgs.tmux}/bin/tmux new-session -s "$selected_name" -c "$selected"
                exit 0
              fi

              if ! ${pkgs.tmux}/bin/tmux has-session -t="$selected_name" 2>/dev/null; then
                ${pkgs.tmux}/bin/tmux new-session -ds "$selected_name" -c "$selected"
              fi

              ${pkgs.tmux}/bin/tmux switch-client -t "$selected_name"
            '';

            tmuxSessionSwitcher = pkgs.writeShellScriptBin "tmux-session-switcher" ''
              selected=$(${pkgs.tmux}/bin/tmux list-sessions -F '#S' | ${pkgs.fzf}/bin/fzf --prompt="Switch session: ") || exit 130

              [[ -z "$selected" ]] && exit 130

              ${pkgs.tmux}/bin/tmux switch-client -t "$selected"
            '';
          in
          # tmux
          ''
            bind-key n display-popup -E "${lib.getExe newNotebook}"
            bind-key m display-popup -E "${lib.getExe zoxideSessionizer}"
            bind-key s display-popup -E "${lib.getExe tmuxSessionSwitcher}"

            set -g @session-wizard 'm'

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

        plugins = with pkgs.tmuxPlugins; [
          fuzzback
          better-mouse-mode
          session-wizard
        ];
      };
    };
}
