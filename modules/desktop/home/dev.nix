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
      # mongosh
      pciutils
      cargo
      postgresql_17
      sbt
      # (sbt.override { jre = pkgs.temurin-bin-21; })
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
      cursor-cli
      gradle
      (pnpm_9.override { withNode = false; })
      nodejs_20
      (inputs.brichka.packages."${system}".brichka)
      (mermaid-cli.overrideAttrs {
        makeWrapperArgs = "--set PUPPETEER_EXECUTABLE_PATH '${lib.getExe pkgs.google-chrome}'";
      })
      _1password-cli
      cargo-dist
    ];

  programs = {
    java = {
      enable = true;
      package = pkgs.temurin-bin-21;
    };
    visidata = {
      enable = true;
      visidatarc = "";
    };
  };

}
