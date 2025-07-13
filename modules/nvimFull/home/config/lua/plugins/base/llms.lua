return {
	-- {
	-- 	"ravitemer/mcphub.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-lualine/lualine.nvim",
	-- 	},
	-- 	build = "bundled_build.lua",
	-- 	config = function()
	-- 		require("mcphub").setup({
	-- 			use_bundled_binary = true,
	-- 			extensions = {
	-- 				avante = {
	-- 					make_slash_commands = true, -- make /slash commands from MCP server prompts
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
			"nvim-lualine/lualine.nvim",
		},
		opts = {
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-3.5-sonnet",
					},
				},
			},

			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true,
					},
				},
			},
		},
	},
	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"stevearc/dressing.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"ibhagwan/fzf-lua",
	-- 		"echasnovski/mini.icons",
	-- 		"ravitemer/mcphub.nvim",
	-- 		{
	-- 			"zbirenbaum/copilot.lua",
	-- 			config = function()
	-- 				require("copilot").setup({})
	-- 			end,
	-- 		},
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 			opts = {
	-- 				default = {
	-- 					embed_image_as_base64 = false,
	-- 					prompt_for_file_name = false,
	-- 					drag_and_drop = {
	-- 						insert_mode = true,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 		{
	-- 			-- Make sure to set this up properly if you have lazy=true
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				file_types = { "markdown", "Avante" },
	-- 			},
	-- 			ft = { "markdown", "Avante" },
	-- 		},
	-- 	},
	-- 	version = false,
	-- 	opts = {
	-- 		provider = "copilot",
	-- 		copilot = {
	-- 			model = "claude-3.5-sonnet",
	-- 			max_tokens = 4096,
	-- 			disabled_tools = {
	-- 				"list_files",
	-- 				"search_files",
	-- 				"read_file",
	-- 				"create_file",
	-- 				"rename_file",
	-- 				"delete_file",
	-- 				"create_dir",
	-- 				"rename_dir",
	-- 				"delete_dir",
	-- 				"bash",
	-- 			},
	-- 		},
	-- 		system_prompt = function()
	-- 			local hub = require("mcphub").get_hub_instance()
	-- 			return hub:get_active_servers_prompt()
	-- 		end,
	-- 		custom_tools = function()
	-- 			return {
	-- 				require("mcphub.extensions.avante").mcp_tool(),
	-- 			}
	-- 		end,
	-- 		selector = {
	-- 			--- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
	-- 			provider = "fzf",
	-- 			-- Options override for custom providers
	-- 			provider_opts = {},
	-- 		},
	-- 		file_selector = {
	-- 			provider = "fzf",
	-- 			provider_opts = {},
	-- 		},
	-- 		web_search_engine = {
	-- 			provider = "searxng",
	-- 		},
	-- 	},
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	build = "make",
	-- },
}
