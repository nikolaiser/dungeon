{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  system,
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
        sync_address =
          if system == "aarch64-darwin" then "" else "https://atuin.${osConfig.nas.baseDomain.public}";
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

      functions = {
        envsource = ''
          for line in (cat $argv | grep -v '^#' |  grep -v '^\s*$' | sed -e 's/=/ /' -e "s/'//g" -e 's/"//g' )                                                                                                            
            set export (string split ' ' $line)                                                                                                                                                                           
            set -gx $export[1] $export[2]                                                                                                                                                                                 
            echo "Exported key $export[1]"                                                                                                                                                                                
          end'';
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
      mouse = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      escapeTime = 10;
      prefix = "C-s";

      extraConfig = # tmux
        let
          alacrittyTerminal = ''
            set-option -ga terminal-overrides ",alacritty:Tc"
            set -g default-terminal "alacritty"
          '';
          footTerminal = ''
            set -ag terminal-overrides ",xterm-256color:RGB"
          '';

          terminal = if system == "aarch64-darwin" then alacrittyTerminal else footTerminal;
        in
        ''
          bind-key m display-popup -E "${lib.exe pkgs.tmux-sessionizer}"

          ${terminal}

          set -g allow-passthrough on

          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          set-option -g status-position top
          set -g status-left-length 20

          unbind -T copy-mode-vi  MouseDragEnd1Pane
          bind   -T copy-mode-vi  MouseDragEnd1Pane send -X copy-selection-no-clear

          unbind -T copy-mode     MouseDragEnd1Pane
          bind   -T copy-mode     MouseDragEnd1Pane send -X copy-selection-no-clear

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
