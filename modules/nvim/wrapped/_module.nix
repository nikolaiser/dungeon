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
    wilder-nvim
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
    git
  ];
  settings.dont_link = true;
  settings.lombokPath = "${pkgs.lombok}/share/java/lombok.jar";
  settings.metalsPath = "${lib.getExe pkgs.metals}";
  # binName = "nvim-wrapped";
  binName = "nvim";

  settings.config_directory = ./config; # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
  # settings.config_directory = "/Users/nikolai.sergeev/.config/nvim-wrapped/"; # or lib.generators.mkLuaInline "vim.fn.stdpath('config')";
}
