return {
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-Left>", "<cmd>TmuxNavigateLeft<cr>" },
			{ "<c-Down>", "<cmd>TmuxNavigateDown<cr>" },
			{ "<c-Up>", "<cmd>TmuxNavigateUp<cr>" },
			{ "<c-Right>", "<cmd>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "n", "o", "x" },
			},
		},
	},
	{
		"otavioschwanck/arrow.nvim",
		dependencies = {
			{ "echasnovski/mini.icons" },
		},
		opts = {
			show_icons = true,
			leader_key = ";", -- Recommended to be a single key
			buffer_leader_key = "m", -- Per Buffer Mappings
		},
	},
}
