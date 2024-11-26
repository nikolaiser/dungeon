return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "markdown" },
		},
	},
	"bullets-vim/bullets.vim",
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {},
			},
		},
	},
}
