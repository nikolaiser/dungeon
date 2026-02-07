{
  dungeon.desktop.homeManager =
    { pkgs, inputs', ... }:
    {

      home.packages =
        with pkgs;

        [
          gh
          kubectl
          kubectx
          pciutils
          postgresql_17
          sbt
          # (sbt.override { jre = pkgs.temurin-bin-21; })
          scala-cli
          usbutils
          just
          nix-output-monitor
          databricks-cli
          claude-code
          cursor-cli
          (pnpm_9.override { withNode = false; })
          # nodejs-slim
          (inputs'.brichka.packages.brichka)
          (mermaid-cli.overrideAttrs {
            makeWrapperArgs = "--set PUPPETEER_EXECUTABLE_PATH '${lib.getExe pkgs.google-chrome}'";
          })
          _1password-cli
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
    };
}
