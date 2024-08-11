{ lib
, pkgs-unstable
, pkgs-master
, config
, ...
}:

let
  metalsPackage = (pkgs-master.metals.override { jre = pkgs-unstable.temurin-bin-21; });
  binPath = lib.makeBinPath (with pkgs-unstable;[
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
    zig
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
  ]);

  parsers = pkgs-unstable.symlinkJoin {
    name = "nvim-ts-parsers";
    paths = with pkgs-unstable.vimPlugins.nvim-treesitter-parsers; [
      c
      lua
      vim
      vimdoc
      query
      python
      bash
      markdown
      markdown_inline
      bash
      go
      java
      javascript
      json
      scala
      lua
      markdown
      markdown_inline
      nix
      python
      regex
      rust
      starlark
      yaml
      html
      css
      sql
      zig
      terraform
      scss
      helm
    ];
  };


  preInit =
    ''
      -- Globals
      vim.g.is_nix_package = 1
      vim.g.metals_binary = "${lib.exe metalsPackage}"
    '';

  nvimConfig =
    let
      cfg = pkgs-unstable.neovimUtils.makeNeovimConfig {
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
          "--add-flags"
          ''--cmd "luafile ${pkgs-unstable.writeText "pre-init.lua" preInit}"''
        ];
    };

  neovim-package =
    (pkgs-unstable.neovim-unwrapped.override {
      treesitter-parsers = { };
    }).overrideAttrs
      (oa: {
        preConfigure =
          oa.preConfigure
          + ''
            cp -f ${parsers}/parser/* $out/lib/nvim/parser/
          '';
        treesitter-parsers = { };
      });
  nvim-wrapped = pkgs-unstable.wrapNeovimUnstable neovim-package nvimConfig;
in
{
  home.packages = [ nvim-wrapped ];

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dungeon/nixos/modules/desktop/home/nvim/config";
    recursive = true;
  };
}
