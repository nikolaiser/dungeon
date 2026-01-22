return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		branch = "main",
		opts = {
			prefer_git = true,
			auto_install = true,
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
			-- Select keymappings
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Function outer region" })
			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Function inner region" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Class outer region" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Class inner region" })

			vim.keymap.set({ "x", "o" }, "aa", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end, { desc = "Parameter outer region" })
			vim.keymap.set({ "x", "o" }, "ia", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end, { desc = "Parameter inner region" })

			vim.keymap.set({ "x", "o" }, "ak", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
			end, { desc = "Block outer region" })
			vim.keymap.set({ "x", "o" }, "ik", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
			end, { desc = "Block inner region" })

			vim.keymap.set({ "x", "o" }, "ai", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects")
			end, { desc = "Conditional outer region" })
			vim.keymap.set({ "x", "o" }, "ii", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects")
			end, { desc = "Conditional inner region" })

			vim.keymap.set({ "x", "o" }, "al", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
			end, { desc = "Loop outer region" })
			vim.keymap.set({ "x", "o" }, "il", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
			end, { desc = "Loop inner region" })

			vim.keymap.set({ "x", "o" }, "a=", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
			end, { desc = "Assignment outer region" })
			vim.keymap.set({ "x", "o" }, "i=", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
			end, { desc = "Assignment inner region" })

			-- Move keymappings
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function" })
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end, { desc = "End of next function" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Previous function" })
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end, { desc = "End of previous function" })

			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class" })
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end, { desc = "End of next class" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Previous class" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end, { desc = "End of previous class" })

			vim.keymap.set({ "n", "x", "o" }, "]k", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
			end, { desc = "Next block" })
			vim.keymap.set({ "n", "x", "o" }, "]K", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
			end, { desc = "End of next block" })
			vim.keymap.set({ "n", "x", "o" }, "[k", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@block.outer", "textobjects")
			end, { desc = "Previous block" })
			vim.keymap.set({ "n", "x", "o" }, "[K", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@block.outer", "textobjects")
			end, { desc = "End of previous block" })

			vim.keymap.set({ "n", "x", "o" }, "]a", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects")
			end, { desc = "Next parameter" })
			vim.keymap.set({ "n", "x", "o" }, "]A", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects")
			end, { desc = "End of next parameter" })
			vim.keymap.set({ "n", "x", "o" }, "[a", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
			end, { desc = "Previous parameter" })
			vim.keymap.set({ "n", "x", "o" }, "[A", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects")
			end, { desc = "End of previous parameter" })
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- put your config here
		end,
	},
}
