{
  dungeon.desktop = {
    os = {
      programs = {
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };
    };
    nixos =
      { pkgs, ... }:
      {

        services = {
          udev.packages = [ pkgs.yubikey-personalization ];
          pcscd.enable = true;
        };

        programs.ssh.startAgent = false;

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
          };
        };

      };
  };
}
