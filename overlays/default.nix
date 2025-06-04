inputs: final: prev:

rec {

  helm-with-plugins = final.wrapHelm final.kubernetes-helm {
    plugins = with final.kubernetes-helmPlugins; [ helm-secrets ];
  };

  mylib = import ../lib { inherit (prev) lib; };

  lib = prev.lib.extend (_: _: { inherit (mylib) exe importAllModules; });

  makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });

}
