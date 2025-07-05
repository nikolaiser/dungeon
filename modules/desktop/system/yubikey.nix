{
  pkgs,
  inputs,
  system,
  ...
}:

{

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    ssh.startAgent = false;
  };

  environment.systemPackages = [
    pkgs.age-plugin-yubikey
    pkgs.agenix-rekey
  ];

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
