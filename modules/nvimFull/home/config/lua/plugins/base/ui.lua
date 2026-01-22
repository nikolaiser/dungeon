return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		config = function()
			vim.cmd.colorscheme("carbonfox")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{ "MunifTanjim/nui.nvim", lazy = true },

	{
		"folke/snacks.nvim",
		opts = {
			input = {},
			notifier = {},
			bigfile = {},
			quickfile = {},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" },
		opts = {},
	},
}
