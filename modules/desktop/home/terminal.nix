{ pkgs, system, ... }:
{
  programs = {
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;
      package = (if system == "aarch64-darwin" then pkgs.ghostty-bin else pkgs.ghostty);
      # clearDefaultKeybinds = true;
      settings = {
        confirm-close-surface = false;
        shell-integration = "fish";
      };
    };
  };
}
