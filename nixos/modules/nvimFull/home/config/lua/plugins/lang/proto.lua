return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "proto" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				protols = {},
			},
		},
	},
}
