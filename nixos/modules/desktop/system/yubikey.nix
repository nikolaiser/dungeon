{ pkgs, ... }:

{

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ssh.startAgent = false;
  };


  security.pam = {
    u2f = {
      enable = true;
      control = "sufficient";
      settings.cue = true;
    };

    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
      swaylock.u2fAuth = true;
      gnome-keyring.u2fAuth = true;
    };
  };


}
