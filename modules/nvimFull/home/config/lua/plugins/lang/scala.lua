return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "scala" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				brichka = {},
			},
		},
	},
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt" },
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
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function(self)
			local metals_config = require("metals").bare_config()

			local clientCapabilities = vim.lsp.protocol.make_client_capabilities()

			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities(clientCapabilities)

			metals_config.capabilities = capabilities

			metals_config.on_attach = function(client, bufnr)
				require("metals").setup_dap()
			end

			-- metals_config.settings = {
			-- 	serverVersion = "2.0.0-M2",
			-- 	serverProperties = {
			-- 		"-Djol.magicFieldOffset=true",
			-- 		"-Djol.tryWithSudo=true",
			-- 		"-Djdk.attach.allowAttachSelf",
			-- 		"--add-opens=java.base/java.nio=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.jvm=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.resources=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
			-- 		"--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
			-- 		"--add-opens=java.base/sun.nio.ch=ALL-UNNAMED",
			-- 		"--add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
			-- 		"--add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED",
			-- 		"--add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
			-- 		"--add-opens=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
			-- 		"-XX:+DisplayVMOutputToStderr",
			-- 		"-Xlog:disable",
			-- 		"-Xlog:all=warning,gc=warning:stderr",
			-- 	},
			-- }

			metals_config.settings = {
				metalsBinaryPath = vim.g.metals_binary,
				showImplicitArguments = true,
				showImplicitConversionsAndClasses = true,
				-- showInferredType = true,
				defaultBspToBuildTool = true,
				serverProperties = { "-Dmetals.enable-best-effort=true" },
				excludedPackages = {},
				fallbackScalaVersion = "3.3.3",
				bloopJvmProperties = { "-Dscala.concurrent.context.maxThreads=4", "-Xmx10g" },
			}

			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				callback = function()
					vim.lsp.inlay_hint.enable(true)
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
		keys = {
			{
				"<leader>cw",
				function()
					require("telescope").extensions.metals.commands()
				end,
				desc = "Metals commands",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				scala = {},
			},
		},
	},
}
