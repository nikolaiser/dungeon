return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		defaults = {
			mappings = {
				i = {
					["<C-Space>"] = require("telescope.actions").to_fuzzy_refine,
				},
			},
		},
	},
	keys = {
		-- Basic
		{
			"<leader> ",
			function()
				require("telescope.builtin").find_files()
			end,
		},
		{
			"<leader>/",
			function()
				require("telescope.builtin").live_grep()
			end,
		},
		{
			"<leader>sb",
			function()
				require("telescope.builtin").buffers()
			end,
		},
		{
			"<leader>sq",
			function()
				require("telescope.builtin").quickfix()
			end,
		},
		{
			"<leader>sj",
			function()
				require("telescope.builtin").jumplist()
			end,
		},
		-- LSP
		{
			"<leader>cu",
			function()
				require("telescope.builtin").lsp_references()
			end,
		},
		{
			"<leader>ci",
			function()
				require("telescope.builtin").lsp_incoming_calls()
			end,
		},
		{
			"<leader>co",
			function()
				require("telescope.builtin").lsp_outgoing_calls()
			end,
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
		},
		{
			"gd",
			function()
				require("telescope.builtin").lsp_definitions()
			end,
		},
		{
			"gi",
			function()
				require("telescope.builtin").lsp_implementations()
			end,
		},
	},
}
