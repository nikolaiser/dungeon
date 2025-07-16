{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{

  # stylix.targets.fish.enable = false;
  # stylix.targets.tmux.enable = false;

  programs = {

    yazi = {
      enable = true;
      enableFishIntegration = true;
      plugins = {
        git = pkgs.yaziPlugins.git;
      };
      initLua = ''
        require("git"):setup()
      '';
      settings = {
        plugin.prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];

      };
    };

    atuin = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      settings = {
        inline_height = "5";
      };
    };

    direnv = {
      enable = true;
      config = {
        global.hide_env_diff = true;
      };
    };

    starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
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

    fish = {
      enable = true;

      shellInit = # fish
        ''
          set -g fish_key_bindings fish_default_key_bindings
          set fish_greeting  # disable greeting
        '';

      shellAliases = {
        ls = "${lib.exe pkgs.eza}";
        la = "${lib.exe pkgs.eza} -la";
        tree = "${lib.exe pkgs.eza} -T";
        htop = "${lib.exe pkgs.bottom}";
        cat = "${lib.exe pkgs.bat}";
        nano = "${lib.exe pkgs.micro}";
        #ga = "git add";
        gc = "git commit";
        #gco = "git checkout";
        gp = "git push";
        ps = "${lib.exe pkgs.procs}";
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
    };

    tmux = {
      enable = true;
      clock24 = true;

      extraConfig = # tmux
        ''
          set -g prefix C-s

          # act like vim
          setw -g mode-keys vi
          bind-key m display-popup -E "${lib.exe pkgs.tmux-sessionizer}"

          set -g default-terminal "tmux-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"

          set-option -g history-limit 50000
          set-option -sg escape-time 10

          set -g allow-passthrough on

          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          set-option -g status-position top
          set -g status-left-length 20



          is_vim_or_hx="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|l?n?hx?x?|fzf)(diff)?$'"
          bind-key -n C-Left if-shell "$is_vim_or_hx" "send-keys C-Left" "select-pane -L"
          bind-key -n C-Down if-shell "$is_vim_or_hx" "send-keys C-Down" "select-pane -D"
          bind-key -n C-Up if-shell "$is_vim_or_hx" "send-keys C-Up" "select-pane -U"
          bind-key -n C-Right if-shell "$is_vim_or_hx" "send-keys C-Right" "select-pane -R"
        '';
    };
  };

}
