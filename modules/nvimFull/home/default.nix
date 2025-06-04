{
  lib,
  pkgs,
  config,
  osConfig,
  inputs,
  system,
  ...
}:

let
  metalsPackage = (pkgs.metals.override { jre = pkgs.temurin-bin-21; });
  binPath = lib.makeBinPath (
    with pkgs;
    [
      bloop
      pyright
      git
      deadnix
      ripgrep
      fd
      nixpkgs-fmt
      nil
      rust-analyzer
      terraform-ls
      gopls
      lua-language-server
      yaml-language-server
      helm-ls
      coursier
      marksman
      vscode-langservers-extracted
      typos-lsp
      nodePackages.bash-language-server
      gcc
      metalsPackage
      markdownlint-cli2
      nodejs_22
      lazygit
      dockerfile-language-server-nodejs
      hadolint
      nixd
      statix
      efm-langserver
      curl
      docker-compose-language-service
      sqlfluff
      taplo
      tree-sitter
      nixfmt-rfc-style
      scalafmt
      stylua
      protols
      ltex-ls
      zls
      execline
      jdt-language-server
      gnumake
    ]
  );

  mcphubPath = inputs.mcphub-nvim.packages."${system}".default;
  uvxCommand = "${pkgs.uv}/bin/uvx";

  preInit = ''
    -- Globals
    vim.g.is_nix_package = 1
    vim.g.metals_binary = "${lib.exe metalsPackage}"
    vim.g.lombok_path = "${pkgs.lombok}/share/java/lombok.jar"
    vim.g.mcphub_path = "${mcphubPath}"
  '';

  nvimConfig =
    let
      cfg = pkgs.neovimUtils.makeNeovimConfig {
        extraName = "";
        vimAlias = false;
        viAlias = false;
        withPython3 = true;
        wrapRc = false;
      };
    in
    cfg
    // {
      wrapperArgs =
        cfg.wrapperArgs
        ++ [
          "--suffix"
          "PATH"
          ":"
          binPath
        ]
        ++ [
          "--set"
          "SEARXNG_API_URL"
          "https://searxng.${osConfig.nas.baseDomain.public}/search"
        ]
        ++ [
          "--add-flags"
          ''--cmd "luafile ${pkgs.writeText "pre-init.lua" preInit}"''
        ];
    };

  # neovim-package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  neovim-package = pkgs.neovim-unwrapped;

  nvim-wrapped = pkgs.wrapNeovimUnstable neovim-package nvimConfig;

  mcphubConfig = {
    mcpServers = {
      nixos = {
        command = uvxCommand;
        args = [ "mcp-nixos" ];
      };
    };
  };
in
{
  home.packages = [ nvim-wrapped ];

  xdg.configFile = {
    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/modules/nvimFull/home/config";
      recursive = true;
    };
    "mcphub/servers.json" = {
      text = builtins.toJSON mcphubConfig;
    };
  };
}
