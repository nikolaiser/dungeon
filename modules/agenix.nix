{
  inputs,
  den,
  self,
  ...
}:

let
  aspect =
    { host, ... }:
    {
      ${host.class} =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.agenix-rekey ];
          imports = [
            inputs.agenix."${host.class}Modules".default
            inputs.agenix-rekey."${host.class}Modules".default
          ];
          nixpkgs.overlays = [ inputs.agenix-rekey.overlays.default ];

          age = {
            rekey = {
              storageMode = "derivation";
              cacheDir = "/var/tmp/agenix-rekey/\"$UID\"";
            };
            identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          };
          nix.settings.extra-sandbox-paths = [ "/var/tmp/agenix-rekey" ];
          systemd.tmpfiles.rules = [ "d /var/tmp/agenix-rekey 1777 root root" ];

        };
    };
in
{
  flake-file = {
    inputs = {
      agenix.url = "github:ryantm/agenix";
      agenix-rekey = {
        url = "github:oddlama/agenix-rekey";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };

  flake = {

    agenix-rekey = inputs.agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
      darwinConfigurations = self.darwinConfigurations or { };
    };
  };

  dungeon.agenix = den.lib.parametric {
    includes = [ aspect ];
  };

}
