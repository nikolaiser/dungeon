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
    type: name: path: args:
    let
      allDirs = getDirs path;
      systemPresent = builtins.elem type allDirs;
      homePresent = builtins.elem "home" allDirs;

      allSystemFiles = if systemPresent then (getRegularFiles "${path}/${type}") else [ ];

      systemModuleFiles = builtins.filter (file: file != "options.nix") allSystemFiles;

      optionsPresent = builtins.elem "options.nix" allSystemFiles;
      otherOptions = if optionsPresent then (import "${path}/${type}/options.nix" args) else { };
      allOptions."${name}" = {
        enable = lib.mkEnableOption "Enable module ${name}";
      }
      // otherOptions;

      systemModules = lib.map (file: (import "${path}/${type}/${file}" args)) systemModuleFiles;
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

  importAll =
    type: path: args:
    let
      moduleDirs = getDirs path;
      modules = lib.map (dir: mkNamedModule type dir "${path}/${dir}" args) moduleDirs;
    in
    modules;

  importAllModules = importAll "system";

  importAllDarwinModules = importAll "darwinSystem";

}
