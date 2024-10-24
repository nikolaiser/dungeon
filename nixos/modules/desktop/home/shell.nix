{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

let
  vim-tmux-navigator-sturdy = pkgs.tmuxPlugins.vim-tmux-navigator.overrideAttrs (final: {
    src = inputs.vim-tmux-navigator-sturdy;
  });

  bar = # lua
    ''
      local a = 5


    '';
in
{

  stylix.targets.fish.enable = false;
  # stylix.targets.tmux.enable = false;

  programs = {

    atuin = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    direnv.enable = true;

    starship = {
      enable = true;

    };

    fish = {
      enable = true;
      interactiveShellInit = # fish
        ''
          if status is-interactive
           and not set -q TMUX
            exec tmux new-session -A -s main
          end
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

    nushell = {
      enable = true;
      configFile.text = # nu
        ''
          def start_tmux [] {
            if 'TMUX' not-in ($env | columns) {
              tmux new-session -A -s main
            }
          }

          start_tmux
        '';

      extraConfig = # nu
        ''
          let carapace_completer = { |spans|
            carapace $spans.0 nushell $spans | from json
          }
          $env.config = {
            show_banner: false,
            completions: {
              case_sensitive: false
              quick: true
              partial: true
              algorithm: "fuzzy"
              external: {
                enable: true
                max_results: 100
                completer: $carapace_completer
              }
            }
          }
        '';
    };

    tmux = {
      enable = true;
      clock24 = true;

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator-sturdy
        dracula
        yank
      ];

      extraConfig = # tmux
        ''
          set -g prefix C-s

          # act like vim
          #setw -g mode-keys vi
          bind-key m display-popup -E "${lib.exe pkgs.tmux-sessionizer}"

          set -g default-terminal "tmux-256color"
          set -ag terminal-overrides ",xterm-256color:RGB"

          set-option -g history-limit 50000
          set-option -sg escape-time 10

          set -g allow-passthrough on

          set -ga update-environment TERM
          set -ga update-environment TERM_PROGRAM

          set -g @dracula-plugins "battery time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-show-location false
          set -g @dracula-show-fahrenheit false
          set -g @dracula-show-left-icon session
          set -g status-position top
          run-shell ${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/dracula/dracula.tmux
        '';
    };
  };

  home.packages = with pkgs; [ tmux-sessionizer ];

  xdg.configFile."tms/config.toml" = {
    text = "search_paths = ['${config.home.homeDirectory}/Documents', '${config.home.homeDirectory}/.config/nvim', '${config.home.homeDirectory}/.config/dungeon' ]";
  };

}
