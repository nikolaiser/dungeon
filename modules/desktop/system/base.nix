{ pkgs, ... }:

{

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-21;
  };

  programs.nix-ld.enable = true;

  services.printing.enable = true;

  programs.dconf.enable = true;
}
