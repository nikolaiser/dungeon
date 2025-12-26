return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local clientCapabilities = vim.lsp.protocol.make_client_capabilities()

			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities(clientCapabilities)

			local configs = require("lspconfig.configs")

			if not configs.brichka then
				configs.brichka = {
					default_config = {
						cmd = { "brichka", "lsp" },
						filetypes = { "sql", "scala" },
						root_dir = function()
							return vim.fn.getcwd()
						end,
						settings = {},
					},
				}
			end

			for server, serverOpts in pairs(opts.servers) do
				serverOpts.capabilities = capabilities
				lspconfig[server].setup(serverOpts)
			end
		end,
	},
	-- {
	-- 	"jmbuhr/otter.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {},
	-- },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			format_after_save = {
				-- timeout_ms = 2000,
				lsp_format = "fallback",
				-- lsp_format = "never",
			},
		},
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
		keys = {
			{
				"<leader>cr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
			},
		},
		config = function(opts)
			require("inc_rename").setup(opts)
		end,
	},
}
