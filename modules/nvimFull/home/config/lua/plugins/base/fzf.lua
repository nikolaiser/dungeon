return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "echasnovski/mini.icons" },
		config = function(opts)
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({ "telescope" })
		end,

		keys = {
			-- Basic
			{
				"<leader> ",
				function()
					require("fzf-lua").files()
				end,
			},
			{
				"<leader>/",
				function()
					require("fzf-lua").live_grep()
				end,
			},
			{
				"<leader>sb",
				function()
					require("fzf-lua").buffers()
				end,
			},
			{
				"<leader>sq",
				function()
					require("fzf-lua").quickfix()
				end,
			},
			-- LSP
			{
				"<leader>cu",
				function()
					require("fzf-lua").lsp_references()
				end,
			},
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_live_workspace_symbols()
				end,
			},
			{
				"gd",
				function()
					require("fzf-lua").lsp_definitions({ jump1 = true })
				end,
			},
			{
				"<leader>ci",
				function()
					require("fzf-lua").lsp_implementations()
				end,
			},
		},
	},
}
