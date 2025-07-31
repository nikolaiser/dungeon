{ pkgs, system, ... }:
{
  programs.ssh.addKeysToAgent = "yes";
  programs.ssh.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = if system == "aarch64-darwin" then pkgs.pinentry_mac else pkgs.pinentry-qt;
  };

}
