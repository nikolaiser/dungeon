return {
  { "williamboman/mason.nvim", enabled = false },
  { "mason.nvim",              enabled = false },
  {
    "scalameta/nvim-metals",
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
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
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
    ft = { "scala", "sbt", "java" },
    config = function(self)
      local metals_config = require("metals").bare_config()

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

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
    "iamcco/markdown-preview.nvim",
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
    opts = {
      document_highlight = { enabled = false },
      capabilities = {
        textDocument = { completion = { completionItem = { snippetSupport = true } } },
      },
      servers = {
        taplo = {
          mason = false,
        },
        nushell = {
          mason = false,
        },
        bashls = {
          mason = false,
        },
        typos_lsp = {
          mason = false,
        },
        nixd = {
          mason = false,
        },
        gopls = {
          mason = false,
        },
        nil_ls = {
          mason = false,
        },
        yamlls = {
          mason = false,
          settings = {
            yaml = {
              format = {
                singleQuote = true
              },
            },
          },
        },
        terraformls = {
          mason = false
        },
        jsonls = {
          mason = false,
        },
        marksman = {
          mason = false
        },
        helm_ls = {
          mason = false,
        },
        dockerls = {
          mason = false
        },
        docker_compose_language_service = {
          mason = false
        },
        fish_lsp = {
          mason = false,
        },
      },
    },
  },
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp"
    },
  }
}
