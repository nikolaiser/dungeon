local grep_opts = {
	"rg",
	"--vimgrep",
	"--hidden",
	"--follow",
	"--glob",
	'"!**/.git/*"',
	"--column",
	"--line-number",
	"--no-heading",
	"--color=always",
	"--smart-case",
	"--max-columns=4096",
	"-e",
}

return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			"telescope",
			grep = {
				cwd_prompt = false,
				cmd = table.concat(grep_opts, " "),
				hidden = true,
				follow = true,
			},
			files = {
				cwd_prompt = false,
				git_icons = true,
				hidden = true,
				follow = true,
			},
		},
		-- config = function(opts)
		-- 	-- calling `setup` is optional for customization
		-- 	require("fzf-lua").setup(opts)
		-- end,

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
