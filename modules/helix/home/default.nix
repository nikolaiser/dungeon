{
  inputs,
  pkgs,
  system,
  config,
  ...
}:

let
  metalsPackage = (pkgs.metals.override { jre = pkgs.temurin-bin-21; });
in
{
  home.packages = [
    inputs.helix.packages.${system}.default
    inputs.steel.packages.${system}.default
    metalsPackage
  ];

  home.sessionVariables.STEEL_HOME = "${config.xdg.dataHome}/steel";
  home.sessionVariables.STEEL_LSP_HOME = "${config.xdg.dataHome}/steel/steel-language-server";

  xdg.configFile = {
    helix = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/modules/helix/home/config";
      recursive = true;
    };
  };
}
