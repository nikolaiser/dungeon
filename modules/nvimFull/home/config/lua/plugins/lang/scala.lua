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
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			{ "nvim-telescope/telescope.nvim" },
		},

		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.on_attach = function(client, bufnr)
				-- your on_attach function
			end

			metals_config.settings.metalsBinaryPath = vim.g.metals_binary

			return metals_config
		end,
		config = function(self, metals_config)
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
