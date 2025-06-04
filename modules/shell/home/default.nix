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

in
{

  # stylix.targets.fish.enable = false;
  # stylix.targets.tmux.enable = false;

  programs = {

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

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator-sturdy
        yank
      ];

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
        '';
    };
  };

}
