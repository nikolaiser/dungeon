{ inputs, ... }:
{
  flake-file = {
    inputs = {
      brichka = {
        url = "github:nikolaiser/brichka";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      superpowers = {
        url = "github:obra/superpowers";
        flake = false;
      };
    };
  };

  dungeon.desktop.homeManager =
    {
      pkgs,
      inputs',
      lib,
      ...
    }:
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
        opencode = {
          enable = true;
          enableMcpIntegration = true;
        };
        mcp = {
          enable = true;
          servers = {

            nixos = {
              command = "nix";
              args = [
                "run"
                "github:utensils/mcp-nixos"
                "--"
              ];
            };
          };
        };
      };
      # Link superpowers source directory (for lib/ access)
      xdg.configFile."opencode/superpowers".source = inputs.superpowers;

      # Copy the plugin and skills files (real copy, not symlink) to avoid potential blocking issues
      # OpenCode's watch mechanism can hang on symlinks in some environments.
      home.activation.setupOpencodeSuperpowers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Setup Plugins
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config/opencode/plugins
        $DRY_RUN_CMD cp -f $VERBOSE_ARG \
          ${inputs.superpowers}/.opencode/plugins/superpowers.js \
          ~/.config/opencode/plugins/superpowers.js
        $DRY_RUN_CMD chmod +w ~/.config/opencode/plugins/superpowers.js

        # Patch plugin paths to point to Nix store for core libs
        $DRY_RUN_CMD sed -i \
          "s|../../lib/skills-core.js|${inputs.superpowers}/lib/skills-core.js|g" \
          ~/.config/opencode/plugins/superpowers.js
        $DRY_RUN_CMD sed -i \
          "s|path.resolve(__dirname, '../../skills')|path.join(os.homedir(), '.config/opencode/skills/superpowers')|g" \
          ~/.config/opencode/plugins/superpowers.js

        # Setup Skills (using CP -R instead of symlink to prevent OpenCode lockup)
        $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config/opencode/skills
        $DRY_RUN_CMD rm -rf ~/.config/opencode/skills/superpowers
        $DRY_RUN_CMD cp -r $VERBOSE_ARG ${inputs.superpowers}/skills ~/.config/opencode/skills/superpowers
        $DRY_RUN_CMD chmod -R +w ~/.config/opencode/skills/superpowers
      '';
    };
}
