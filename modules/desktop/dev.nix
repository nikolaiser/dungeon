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
          codex
          cursor-cli
          (pnpm.override { withNode = false; })
          nodejs_22
          (inputs'.brichka.packages.brichka)
          (mermaid-cli.overrideAttrs {
            makeWrapperArgs = "--set PUPPETEER_EXECUTABLE_PATH '${lib.getExe pkgs.google-chrome}'";
          })
          _1password-cli
          uv
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
        opencode.enable = true;
      };
    };
}
