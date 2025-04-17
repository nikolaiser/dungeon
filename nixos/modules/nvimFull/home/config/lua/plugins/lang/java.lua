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
					local config = {
						cmd = {
							"jdtls",
							string.format("--jvm-arg=-javaagent:%s", vim.g.lombok_path),
							string.format("--jvm-arg=-Xbootclasspath/a:%s", vim.g.lombok_path),
						},
						root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
					}

					require("jdtls").start_or_attach(config)
				end,
			})
		end,
	},
}
