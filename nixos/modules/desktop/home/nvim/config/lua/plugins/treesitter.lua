return { {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    prefer_git = true,
    ensure_installed = { "fish", "tmux", "bash", "scala", "nix" },
  },
  dependencies = {
    -- NOTE: additional parser
    { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
  },
  build = ":TSUpdate",
} }
