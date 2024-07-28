return {
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = { inc_rename = true },
    },
  },
  --- lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    dependencies = {
      "b0o/SchemaStore.nvim",
      "smjonas/inc-rename.nvim"
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true;


      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

      lspconfig.typos_lsp.setup {}

      lspconfig.bashls.setup {}


      -- Nix config
      lspconfig.nil_ls.setup {
        capabilities = capabilities,
        settings = {
          ['nil'] = {
            formatting = {
              command = { 'nixpkgs-fmt' },
            },
            diagnostics = {
              ignored = { 'uri_literal' },
              excludedFiles = {},
            },
          },
        },
      }

      -- Rust config
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            imports = {
              granularity = {
                group = 'module',
              },
              prefix = 'self',
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
            },
          },
        },
      }

      -- Terraform config
      lspconfig.terraformls.setup {
        capabilities = capabilities,
      }

      -- Go config
      lspconfig.gopls.setup {
        capabilities = capabilities,
      }

      -- Lua config
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {
                'vim',
                'require'
              },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        }
      }

      -- Yaml config
      lspconfig.yamlls.setup {
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas(),
            -- schemas = {
            --   ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            --   ['https://json.schemastore.org/github-action.json'] = '*/action.yaml',
            -- },
          },
        },
      }

      lspconfig.jsonls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            -- schemas = {
            --   ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
            --   ['https://json.schemastore.org/github-action.json'] = '*/action.yaml',
            -- },
          },
        },
      }


      -- Helm config
      lspconfig.helm_ls.setup {
        capabilities = capabilities,
        settings = {
          ['helm-ls'] = {
            yamlls = {
              path = 'yaml-language-server',
            },
          },
        },
      }

      lspconfig.marksman.setup {
        capabilities = capabilities,
      }

      require 'lspconfig'.html.setup {
        capabilities = capabilities,
        cmd = { "vscode-html-language-server", "--stdio" },
        config = {
          provideFormatter = true
        }
      }

      require 'lspconfig'.cssls.setup {
        capabilities = capabilities,
        cmd = { "vscode-css-language-server", "--stdio" }
      }
    end,
    keys = {
      {
        '<leader>cl',
        '<cmd>LspInfo<cr>',
        desc = 'Lsp Info',
      },
      {
        'gd',
        function()
          require('telescope.builtin').lsp_definitions { reuse_win = true }
        end,
        desc = 'Goto Definition',
      },
      {
        'gr',
        '<cmd>Telescope lsp_references<cr>',
        desc = 'References',
        nowait = true,
      },
      {
        'gD',
        vim.lsp.buf.declaration,
        desc = 'Goto Declaration',
      },
      {
        'gI',
        function()
          require('telescope.builtin').lsp_implementations { reuse_win = true }
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          require('telescope.builtin').lsp_type_definitions { reuse_win = true }
        end,
        desc = 'Goto T[y]pe Definition',
      },
      {
        'K',
        vim.lsp.buf.hover,
        desc = 'Hover',
      },
      {
        'gK',
        vim.lsp.buf.signature_help,
        desc = 'Signature Help',
      },
      {
        '<c-k>',
        vim.lsp.buf.signature_help,
        mode = 'i',
        desc = 'Signature Help',
      },
      {
        '<leader>ca',
        vim.lsp.buf.code_action,
        desc = 'Code Action',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cc',
        vim.lsp.codelens.run,
        desc = 'Run Codelens',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cC',
        vim.lsp.codelens.refresh,
        desc = 'Refresh & Display Codelens',
        mode = { 'n' },
      },
      {
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Rename (inc-rename.nvim)",
      },
      {
        '<leader>cA',
        function()
          vim.lsp.buf.code_action {
            context = {
              only = {
                'source',
              },
              diagnostics = {},
            },
          }
        end,
        desc = 'Source Action',
      },
    },
  },
  {
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
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
        end
      },
    },
    ft = { 'scala', 'sbt', 'java' },
    config = function(self)
      local metals_config = require('metals').bare_config()

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

      metals_config.settings = {
        metalsBinaryPath = vim.g.metals_binary,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        defaultBspToBuildTool = true,
        excludedPackages = {},
        fallbackScalaVersion = '3.3.3',
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
        '<leader>me',
        function()
          require('telescope').extensions.metals.commands()
        end,
        desc = 'Metals commands',
      },
    },
  },
  {
    'towolf/vim-helm',
    ft = 'helm'
  }

}
