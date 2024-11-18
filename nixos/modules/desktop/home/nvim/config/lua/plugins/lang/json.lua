return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "json" },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = {
      servers = {
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.json.schemas or {},
              require("schemastore").json.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            json = {
              validate = { enable = true },
            }
          }
        }
      }
    }
  }
}
