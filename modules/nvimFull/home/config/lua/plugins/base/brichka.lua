return {
	dependencies = {
		"folke/snacks.nvim", -- For default renderers. Can be removed if overwritten
	},
	"nikolaiser/brichka.nvim",
	-- dir = "~/Documents/brichka.nvim",
	opts = {
		cmd = {
			brichka = "/Users/nikolai.sergeev/Documents/brichka/target/release/brichka",
		},
		run = {
			init = true,
		},
	},
	keys = {
		{
			"<leader>bs",
			function()
				require("brichka.cluster").select()
			end,
			desc = "Brichka select cluster",
			mode = { "n" },
		},
		{
			"<leader>br",
			function()
				require("brichka.run").run(vim.api.nvim_buf_get_lines(0, 0, -1, false), vim.bo.filetype)
			end,
			desc = "Brichka execute current buffer",
			mode = { "n" },
		},
	},
}
