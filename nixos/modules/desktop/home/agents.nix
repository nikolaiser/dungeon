{ pkgs, ... }:
{
  programs.ssh.addKeysToAgent = "yes";
  programs.ssh.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.gnome-keyring.enable = true;
}
