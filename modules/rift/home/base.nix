{ pkgs, inputs, ... }:
let
  # rustPackage = pkgs.rust-bin.stable.latest.minimal;
  # rustPlatform = pkgs.makeRustPlatform {
  #   cargo = rustPackage;
  #   rustc = rustPackage;
  # };

  cargoToml = builtins.fromTOML (builtins.readFile "${inputs.rift}/Cargo.toml");

  riftPackage = pkgs.rustPlatform.buildRustPackage {
    inherit (cargoToml.package) name version;
    src = inputs.rift;
    cargoLock = {
      outputHashes = {
        "continue-0.1.1" = "9irDEeiPbjIG3e1F/jpWd3fCL1/nei/IYjhMqRp+Q+s=";
        "dispatchr-1.0.0" = "Df6PdDA5bpmy2P30vGdad+EiHJiANmHrRF2q75Uegik=";
      };
      lockFile = "${inputs.rift}/Cargo.lock";
    };
  };
in
{
  home.packages = [ riftPackage ];

  home = {

    file.".config/rift/config.toml".source = ./config/config.toml;
  };

  launchd.agents.rift = {
    enable = true;
    config = {
      ProgramArguments = [ "${riftPackage}/bin/rift" ];
      RunAtLoad = true;
      StandardOutPath = "/tmp/rift.log";
      StandardErrorPath = "/tmp/rift.err.log";
    };
  };
}
