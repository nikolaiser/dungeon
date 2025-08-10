return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = false,
				hide_during_completion = true,
				keymap = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		opts = {},
	},
}
