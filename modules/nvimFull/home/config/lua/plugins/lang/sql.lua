return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = { "sql" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				scheme = { "sql_formatter" },
			},
		},
	},
}
