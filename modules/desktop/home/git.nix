{ pkgs, lib, ... }:
let
  gitConfig = {
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

in
{

  programs.git = {
    enable = true;
    aliases = {
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };
    extraConfig = gitConfig;
    ignores = [
      "*.bloop"
      "*.bsp"
      "*.metals"
      "*.metals.sbt"
      "*metals.sbt"
      "*.direnv"
      #"*.envrc" # there is lorri, nix-direnv & simple direnv; let people decide
      "*hie.yaml" # ghcide files
      "*.mill-version" # used by metals
      "*.jvmopts" # should be local to every project
    ];
    userEmail = "mail@nikolaiser.com";
    userName = "nikolaiser";
  };

  programs.scmpuff = {
    enable = true;
    enableFishIntegration = true;
    enableAliases = true;
  };
}
