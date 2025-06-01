{
  inputs,
  pkgs,
  system,
  config,
  ...
}:

{
  home.packages = [
    inputs.helix.packages.${system}.default
    inputs.steel.packages.${system}.default
  ];

  xdg.dataFile.steel.source = inputs.helix.packages.${system}.helix-cogs;
  home.sessionVariables.STEEL_HOME = "${config.xdg.dataHome}/steel";
  home.sessionVariables.STEEL_LSP_HOME = "${config.xdg.dataHome}/steel/steel-language-server";

  xdg.configFile = {
    helix = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/nixos/modules/helix/home/config";
      recursive = true;
    };
  };
}
