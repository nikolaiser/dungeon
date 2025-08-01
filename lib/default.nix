{ lib, ... }:

rec {

  getFilesWithType =
    type: dir:
    lib.mapAttrsToList (f: _: f) (lib.filterAttrs (_: t: t == type) (builtins.readDir "${dir}"));

  getRegularFiles = getFilesWithType "regular";

  getDirs = getFilesWithType "directory";

  /*
    Return first binary executable name of the given derivation
    Type:
      exe :: Derivation -> String
  */
  exe =
    drv:
    let
      regFiles = getRegularFiles "${drv}/bin";
      mainProg = drv.meta.mainProgram or (lib.head regFiles);
    in
    "${drv}/bin/${mainProg}";

  mkNamedModule =
    name: path: args:
    let
      allDirs = getDirs path;
      systemPresent = builtins.elem "system" allDirs;
      homePresent = builtins.elem "home" allDirs;

      allSystemFiles = if systemPresent then (getRegularFiles "${path}/system") else [ ];

      systemModuleFiles = builtins.filter (file: file != "options.nix") allSystemFiles;

      optionsPresent = builtins.elem "options.nix" allSystemFiles;
      otherOptions = if optionsPresent then (import "${path}/system/options.nix" args) else { };
      allOptions."${name}" = {
        enable = lib.mkEnableOption "Enable module ${name}";
      }
      // otherOptions;

      systemModules = lib.map (file: (import "${path}/system/${file}" args)) systemModuleFiles;
      homeFiles = if homePresent then (getRegularFiles "${path}/home") else [ ];
      homeModules = lib.map (file: "${path}/home/${file}") homeFiles;
    in
    {
      options = allOptions;

      config = lib.mkIf args.config."${name}".enable (
        lib.mkMerge (
          systemModules
          ++ [
            {
              home-manager.users.${args.config.shared.username}.imports = homeModules;
            }
          ]
        )
      );
    };

  importAllModules =
    path: args:
    let
      moduleDirs = getDirs path;
      modules = lib.map (dir: mkNamedModule dir "${path}/${dir}" args) moduleDirs;
    in
    modules;

  mkNamedHmModule =
    name: path: args:
    let
      allDirs = getDirs path;
      homePresent = builtins.elem "home" allDirs;

      allHomeFiles = if homePresent then (getRegularFiles "${path}/home") else [ ];

      homeModuleFiles = builtins.filter (file: file != "options.nix") allHomeFiles;

      optionsPresent = builtins.elem "options.nix" allHomeFiles;
      otherOptions = if optionsPresent then (import "${path}/home/options.nix" args) else { };
      allOptions."${name}" = {
        enable = lib.mkEnableOption "Enable module ${name}";
      }
      // otherOptions;

      homeModules = lib.map (file: (import "${path}/home/${file}" args)) homeModuleFiles;
    in
    {
      options = allOptions;

      config = lib.mkIf args.config."${name}".enable (lib.mkMerge (homeModules));
    };

  importAllHmModules =
    path: args:
    let
      moduleDirs = getDirs path;
      modules = lib.map (dir: mkNamedHmModule dir "${path}/${dir}" args) moduleDirs;
    in
    modules;

}
