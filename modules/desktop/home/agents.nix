{ pkgs, system, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = true;
    addKeysToAgent = "yes";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = if system == "aarch64-darwin" then pkgs.pinentry_mac else pkgs.pinentry-qt;
  };

}
