{
  inputs,
  pkgs,
  system,
  config,
  lib,
  ...
}:

let
  metalsPackage = (pkgs.metals.override { jre = pkgs.temurin-bin-21; });
  binPath = lib.makeBinPath (
    with pkgs;
    [
      metalsPackage
      inputs.steel.packages.${system}.default
      nil
      nixd
      #schemat
      tmux
      nixfmt
    ]
  );
  helixWrapped = pkgs.writeShellScriptBin "hx" ''
    export PATH=$PATH:${binPath}
    export STEEL_HOME=${config.xdg.dataHome}/steel
    export STEEL_LSP_HOME=${config.xdg.dataHome}/steel/steel-language-server
    exec ${inputs.helix.packages.${system}.default}/bin/hx "$@"
  '';
in
{
  stylix.targets.helix.enable = lib.mkForce true;

  home.packages = [
    helixWrapped
  ];

  xdg.configFile = {
    helix = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}dungeon/modules/helix/home/config";
      recursive = true;
    };
  };
}
