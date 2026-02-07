return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "java" },
		},
	},
	{
		"mfussenegger/nvim-jdtls",
		dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
		config = function()
			-- Autocmd
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "java" },
				callback = function()
					local jdtls = require("jdtls")

					local config = {
						cmd = {
							"jdtls",
							string.format("--jvm-arg=-javaagent:%s", vim.g.lombok_path),
							-- string.format("--jvm-arg=-Xbootclasspath/a:%s", vim.g.lombok_path),
						},
						root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
						settings = {
							extendedClientCapabilities = jdtls.extendedClientCapabilities,
							java = {
								implementationsCodeLens = {
									enabled = true,
								},
								referencesCodeLens = {
									enabled = true,
								},
								format = {
									enabled = false,
								},
							},
						},
					}

					jdtls.start_or_attach(config)
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				java = { lsp_fallback = false },
			},
		},
	},
}
