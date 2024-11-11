return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "scala" },
    },
  },
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end,
      },
    },
    config = function(self)
      local metals_config = require("metals").bare_config()

      local clientCapabilities = vim.lsp.protocol.make_client_capabilities()

      local blink = require('blink.cmp')
      local capabilities = blink.get_lsp_capabilities(clientCapabilities)

      metals_config.capabilities = capabilities

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

      metals_config.settings = {
        metalsBinaryPath = vim.g.metals_binary,
        -- showImplicitArguments = true,
        -- showImplicitConversionsAndClasses = true,
        -- showInferredType = true,
        defaultBspToBuildTool = true,
        excludedPackages = {},
        fallbackScalaVersion = "3.3.3",
      }

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
    keys = {
      {
        "<leader>me",
        function()
          require("telescope").extensions.metals.commands()
        end,
        desc = "Metals commands",
      },
    },
  },
  {
    "rgroli/other.nvim",
    opts = {
      mappings = {
        {
          pattern = "^(.*)/main/(.*)%.scala$",
          target = "%1/test/%2Spec.scala",
          context = "test",
        },
        {
          pattern = "^(.*)%.scala$",
          target = "%1Live.scala",
          context = "live",
        },

      }
    }
  }

}
