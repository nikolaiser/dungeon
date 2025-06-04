return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "helm" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { { "towolf/vim-helm", ft = "helm" } },
		opts = {
			servers = {
				helm_ls = {
					yamlls = {
						enable = false,
					},
				},
			},
		},
	},
}
