{ inputs, inputs' }:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
let

  pluginsFromPrefix =
    prefix: inputs:
    lib.pipe inputs [
      builtins.attrNames
      (builtins.filter (s: lib.hasPrefix prefix s))
      (map (
        input:
        let
          name = lib.removePrefix prefix input;
        in
        {
          inherit name;
          value = config.nvim-lib.mkPlugin name inputs.${input};
        }
      ))
      builtins.listToAttrs
    ];
  neovimPlugins = pluginsFromPrefix "plugins-" inputs;
  #
  # metals-version = "1.6.5";
  # metals-pkg = pkgs.stdenv.mkDerivation (finalAttrs: {
  #   name = "metals";
  #   version = metals-version;
  #
  #   deps = pkgs.stdenv.mkDerivation {
  #     name = "metals-deps";
  #     version = metals-version;
  #     buildCommand = ''
  #       export COURSIER_CACHE=$(pwd)
  #       mkdir -p $out/bin
  #       ${pkgs.coursier}/bin/cs bootstrap org.scalameta:metals_2.13:${metals-version} \
  #         -r bintray:scalacenter/releases \
  #         -r sonatype:snapshots \
  #         --repository "https://central.sonatype.com/repository/maven-snapshots" \
  #         --standalone \
  #         -o $out/bin/metals-launcher
  #     '';
  #     outputHashMode = "recursive";
  #     outputHashAlgo = "sha256";
  #     outputHash = "sha256-/l3DPDRkaocDFedPpogD01HO5pfyGhPXzAz2slxA1FY=";
  #   };
  #
  #   nativeBuildInputs = [ pkgs.makeWrapper ];
  #   buildInputs = [ finalAttrs.deps ];
  #   dontUnpack = true;
  #   extraJavaOpts = "-XX:+UseG1GC" + "-XX:+UseStringDeduplication" + "-Xss4m" + "-Xms100m";
  #
  #   installPhase = ''
  #     mkdir -p $out/bin
  #
  #     makeWrapper ${finalAttrs.deps}/bin/metals-launcher $out/bin/metals \
  #       --set JAVA_HOME ${pkgs.jre} --add-flags ${finalAttrs.extraJavaOpts}
  #   '';
  # });
in
{
  imports = [ wlib.wrapperModules.neovim ];
  specs.general = with pkgs.vimPlugins; [
    neo-tree-nvim
    neovimPlugins.nightfox
    mini-icons
    mini-ai
    mini-surround
    mini-pairs
    mini-splitjoin
    mini-operators
    blink-cmp
    friendly-snippets
    gitsigns-nvim
    fzf-lua
    snacks-nvim
    hunk-nvim
    nvim-web-devicons
    multicursor-nvim
    lze
    vim-tmux-navigator
    arrow-nvim
    nvim-spider
    nvim-treesitter-textobjects
    nui-nvim
    lualine-nvim
    nvim-lspconfig
    nvim-metals
    conform-nvim
    vim-helm
    nvim-jdtls
    lazydev-nvim
    crates-nvim
    fidget-nvim
    neovimPlugins.brichka
    nvim-treesitter.withAllGrammars
    noice-nvim
  ];

  extraPackages = with pkgs; [
    gofumpt
    gopls
    helm-ls
    yaml-language-server
    jdt-language-server
    stylua
    nixd
    nixfmt
    pyright
    inputs'.brichka.packages.brichka
    rust-analyzer
    rustc
    gopls
    lua-language-server
    vscode-langservers-extracted
    emmylua-ls
    imagemagick
    coursier
    metals
    # metals-pkg
    git
  ];
  settings.dont_link = true;
  settings.lombokPath = "${pkgs.lombok}/share/java/lombok.jar";
  settings.metalsPath = "${lib.getExe pkgs.metals}";
  settings.snippetsPath = ./config/snippets;
  # binName = "nvim-wrapped";
  binName = "nvim";

  settings.config_directory = ./config; # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
  # settings.config_directory = "/Users/nikolai.sergeev/.config/nvim-wrapped/"; # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
}
