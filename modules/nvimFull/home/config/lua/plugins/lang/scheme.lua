return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = { "scheme" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				scheme = { "schemat" },
			},
		},
	},
}
