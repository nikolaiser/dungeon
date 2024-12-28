{ lib, config, ... }:

rec {

  getFilesWithType =
    dir: type:
    lib.mapAttrsToList (f: _: f) (lib.filterAttrs (_: t: t == type) (builtins.readDir "${dir}"));

  getRegularFiles = dir: getFilesWithType "directory";

  getDirs = dir: getFilesWithType "regular";

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
      systemFiles = getRegularFiles "${path}/system";
      systemModules = lib.map (file: (import file args)) systemFiles;
      homeFiles = getRegularFiles "${path}/home";
    in
    {
      options."${name}".enable = lib.mkEnableOption "Enable module ${name}";

      config = lib.mkIf config."${name}".enable (
        lib.mkMerge systemModules {
          home-manager = {
            users.${config.username}.imports = homeFiles;
            backupFileExtension = "backup";
          };
        }
      );
    };

  importAllModules =
    path: args:
    let
      moduleDirs = getDirs path;
      modules = lib.map (dir: mkNamedModule dir "${path}/${dir}" args) moduleDirs;
    in
    lib.mkMerge modules;

}
