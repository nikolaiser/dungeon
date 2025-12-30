{
  pkgs,
  inputs,
  system,
  ...
}:

{

  home.packages =
    with pkgs;

    [
      gh
      kubectl
      kubectx
      mongosh
      pciutils
      cargo
      postgresql_17
      (sbt.override { jre = pkgs.temurin-bin-11; })
      scala_3
      scala-cli
      usbutils
      just
      visualvm
      nix-output-monitor
      xplr
      lf
      databricks-cli
      databricks-sql-cli
      claude-code
      gradle
      (pnpm_9.override { withNode = false; })
      nodejs_20
      (inputs.brichka.packages."${system}".brichka)
      visidata
    ];

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-11;
  };

}
