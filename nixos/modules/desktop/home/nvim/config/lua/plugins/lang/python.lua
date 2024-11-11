return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {

        }
      }
    }
  },
  {
    "rgroli/other.nvim",
    opts = {
      mappings = {
        "python",
      }
    }
  }

}
