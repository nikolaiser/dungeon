{
  system,
  pkgs,
  lib,
  ...
}:
{

  programs.aerospace = {
    enable = (system == "aarch64-darwin");

    package = pkgs.aerospace.overrideAttrs (prev: {
      version = "0.1.2";
      src = pkgs.fetchzip {
        url = "https://github.com/BarutSRB/HyprSpace/releases/download/v0.1.2/AeroSpace-v0.1.2.zip";
        sha256 = "sha256-HEPkvq4UhIuj86h7xX31ErTELLlKxdvE+HTLZeOS208=";
      };
      doInstallCheck = false;
    });

    launchd.enable = true;

  };

  home = {

    file.".config/aerospace/aerospace.toml".source = lib.mkForce ./aerospace/config.toml;
  };

}
