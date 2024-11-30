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
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				backgrounds = {},
			},
			code = {
				disable_background = true,
			},
		},
	},
}
