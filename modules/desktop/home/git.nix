{ pkgs, lib, ... }:
{

  programs = {
    git = {
      enable = true;

      ignores = [
        ".direnv"
        "bin"
        ".metals"
        "project/metals.sbt"
        "project/project"
        ".bloop"
      ];

      settings = {
        alias = {
          ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
          ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        };
        user = {
          email = "mail@nikolaiser.com";
          name = "nikolaiser";
        };

        signing = {
          key = "980B9E9C5686F13A";
          signByDefault = true;
        };

        core = {
          editor = "nvim";
          pager = "${lib.exe pkgs.diff-so-fancy} | less --tabs=4 -RFX";
        };
        diff.tool = "vimdiff";
        merge.tool = "vimdiff";
        difftool.prompt = false;
        mergetool.prompt = true;
        "difftool \"vimdiff\"".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
        "mergetool \"vimdiff\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "mail@nikolaiser.com";
          name = "nikolaiser";
          git = {
            push-bookmark-prefix = "origin";
            auto-track = true;
          };
        };
        ui = {
          diff-editor = [
            "nvim"
            "-c"
            "DiffEditor $left $right $output"
          ];
        };
        remotes.origin.auto-track-bookmarks = "*";
      };
    };
  };

  programs.scmpuff = {
    enable = true;
    enableFishIntegration = true;
    enableAliases = true;
  };
}
