{ pkgs, ... }:
{
  programs.ssh.addKeysToAgent = "yes";
  programs.ssh.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };

}
