vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.syntax = "on"
vim.o.smoothscroll = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.cmdheight = 1
vim.o.wrap = true
vim.o.confirm = true
vim.o.termguicolors = true

-- vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

vim.filetype.add({
	extension = {
		sc = "scala",
	},
})

vim.keymap.set({ "i", "x", "n", "s" }, "<C-t>", "<cmd>w<cr><esc>", { desc = "Save File" })
-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", '<leader>"', "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>%", "<C-W>v", { desc = "Split Window Right", remap = true })

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run)

local function augroup(name)
	return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("man_unlisted"),
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "setlocal formatoptions-=cro",
})

require("lze").load({
	{
		"nightfox",
		lazy = false,
		after = function()
			vim.cmd.colorscheme("carbonfox")
		end,
	},
	{
		"neo-tree.nvim",
		after = function()
			local opts = {
				filesystem = {
					bind_to_cwd = false,
					follow_current_file = { enabled = true },
					filtered_items = {
						hide_dotfiles = false,
					},
				},
				window = {
					mappings = {
						["<space>"] = "none",
					},
				},
			}
			require("neo-tree").setup(opts)
		end,
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Toggle NeoTree",
			},
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer Explorer",
			},
		},
	},
	{
		"blink.cmp",
		event = "InsertEnter",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.default",
		},
		version = "*",
		after = function()
			require("blink.cmp").setup({
				keymap = { preset = "enter" },
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = {
					accept = {
						auto_brackets = {
							enabled = false,
						},
					},
					menu = {
						draw = {
							treesitter = { "lsp" },
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
					ghost_text = {
						enabled = vim.g.ai_cmp,
					},
				},

				-- experimental signature help support
				-- signature = { enabled = true },

				sources = {
					-- adding any nvim-cmp sources here will enable them
					-- with blink.compat
					default = {
						"lazydev",
						"lsp",
						"path",
						"snippets",
						"buffer",
					},
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
						snippets = {
							opts = {
								friendly_snippets = true,
								search_paths = { require(vim.g.nix_info_plugin_name)(nil, "settings", "snippetsPath") },
							},
						},
					},
				},
			})
		end,
	},
	{
		"mini.ai",
		event = "DeferredUIEnter",
		dependencies = {
			"lewis6991/gitsigns.nvim",
		},
		after = function()
			local function ai_buffer(ai_type)
				local start_line, end_line = 1, vim.fn.line("$")
				if ai_type == "i" then
					-- Skip first and last blank lines for `i` textobject
					local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
					-- Do nothing for buffer with all blanks
					if first_nonblank == 0 or last_nonblank == 0 then
						return { from = { line = start_line, col = 1 } }
					end
					start_line, end_line = first_nonblank, last_nonblank
				end

				local to_col = math.max(vim.fn.getline(end_line):len(), 1)
				return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
			end

			local ai = require("mini.ai")
			local opts = {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer", "@assignment.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner", "@assignment.inner" },
					}),

					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = ai.gen_spec.treesitter({ a = "@type.outer", i = "@type.inner" }),
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = ai_buffer,
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
			require("mini.ai").setup(opts)
		end,
	},
	{
		"mini.pairs",
		event = "DeferredUIEnter",
		after = function()
			local opts = {
				modes = { insert = true, command = true, terminal = false },
				skip_unbalanced = false,
				markdown = false,
			}
			require("mini.pairs").setup(opts)
		end,
	},
	{
		"mini.surround",
		after = function()
			local opts = {
				mappings = {},
				n_lines = 100,
			}
			require("mini.surround").setup(opts)
		end,
	},

	{
		"mini.splitjoin",
		after = function()
			local opts = {
				mappings = {
					toggle = "<leader>cj",
				},
			}
			require("mini.splitjoin").setup(opts)
		end,
	},
	{
		"mini.operators",
		after = function()
			require("mini.operators").setup()
		end,
	},
	{ "mini.icons" },
	{
		"gitsigns.nvim",
		after = function()
			local opts = {
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]h", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[h", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>ghs", gitsigns.stage_hunk)
					map("n", "<leader>ghr", gitsigns.reset_hunk)
					map("v", "<leader>ghs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>ghr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>ghS", gitsigns.stage_buffer)
					map("n", "<leader>ghu", gitsigns.undo_stage_hunk)
					require("fidget").setup({})
					map("n", "<leader>ghR", gitsigns.reset_buffer)
					map("n", "<leader>ghp", gitsigns.preview_hunk)
					map("n", "<leader>ghb", function()
						gitsigns.blame_line({ full = true })
					end)
					map("n", "<leader>gtb", gitsigns.toggle_current_line_blame)
					map("n", "<leader>ghd", gitsigns.diffthis)
					map("n", "<leader>ghD", function()
						gitsigns.diffthis("~")
					end)
					map("n", "<leader>gtd", gitsigns.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			}

			require("gitsigns").setup(opts)
		end,
	},
	{
		"fzf-lua",
		lazy = false,
		-- optional for icon support

		after = function()
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
			local opts = {
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
				ui_select = true,
			}
			require("fzf-lua").setup(opts)
		end,
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
	{
		"snacks.nvim",
		lazy = false,
		after = function()
			local opts = {
				image = {},
				bigfile = {},
				notifier = {},
			}
			require("snacks").setup(opts)
		end,
	},
	{
		"julienvincent/hunk.nvim",
		cmd = { "DiffEditor" },
		after = function()
			local opts = {
				keys = {
					global = {
						quit = { "q" },
						accept = { "<leader><Cr>" },
						focus_tree = { "<leader>e" },
					},

					tree = {
						expand_node = { "l", "<Right>" },
						collapse_node = { "h", "<Left>" },

						open_file = { "<Cr>" },

						toggle_file = { "a" },
					},

					diff = {
						toggle_hunk = { "A" },
						toggle_line = { "a" },
						-- This is like toggle_line but it will also toggle the line on the other
						-- 'side' of the diff.
						toggle_line_pair = { "s" },

						prev_hunk = { "[h" },
						next_hunk = { "]h" },

						-- Jump between the left and right diff view
						toggle_focus = { "<Tab>" },
					},
				},

				ui = {
					tree = {
						-- Mode can either be `nested` or `flat`
						mode = "flat",
						width = 35,
					},
					--- Can be either `vertical` or `horizontal`
					layout = "vertical",
				},

				icons = {
					enable_file_icons = true,

					selected = "󰡖",
					deselected = "",
					partially_selected = "󰛲",

					folder_open = "",
					folder_closed = "",

					expanded = "",
					collapsed = "",
				},
				-- Called right after each window and buffer are created.
				hooks = {
					---@param _context { buf: number, tree: NuiTree, opts: table }
					on_tree_mount = function(_context) end,
					---@param _context { buf: number, win: number }
					on_diff_mount = function(_context) end,
				},
			}
			require("hunk").setup(opts)
		end,
	},
	{
		"multicursor.nvim",
		after = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local set = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			set({ "n", "x" }, "<M-up>", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "x" }, "<M-down>", function()
				mc.lineAddCursor(1)
			end)

			-- Add or skip adding a new cursor by matching word/selection
			set({ "n", "x" }, "<leader>n", function()
				mc.matchAddCursor(1)
			end)
			set({ "n", "x" }, "<leader>s", function()
				mc.matchSkipCursor(1)
			end)
			set({ "n", "x" }, "<leader>N", function()
				mc.matchAddCursor(-1)
			end)
			set({ "n", "x" }, "<leader>S", function()
				mc.matchSkipCursor(-1)
			end)

			-- Add and remove cursors with control + left click.
			set("n", "<c-leftmouse>", mc.handleMouse)
			set("n", "<c-leftdrag>", mc.handleMouseDrag)
			set("n", "<c-leftrelease>", mc.handleMouseRelease)

			-- Disable and enable cursors.
			set({ "n", "x" }, "<c-q>", mc.toggleCursor)

			-- Pressing `gaip` will add a cursor on each line of a paragraph.
			set("n", "ga", mc.addCursorOperator)

			-- Clone every cursor and disable the originals.
			set({ "n", "x" }, "<leader><c-q>", mc.duplicateCursors)

			-- Align cursor columns.
			set("n", "<leader>a", mc.alignCursors)

			-- Split visual selections by regex.
			set("x", "S", mc.splitCursors)

			-- match new cursors within visual selections by regex.
			set("x", "M", mc.matchCursors)

			-- bring back cursors if you accidentally clear them
			set("n", "<leader>gv", mc.restoreCursors)

			-- Add a cursor for all matches of cursor word/selection in the document.
			set({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

			-- Rotate the text contained in each visual selection between cursors.
			set("x", "<leader>t", function()
				mc.transposeCursors(1)
			end)
			set("x", "<leader>T", function()
				mc.transposeCursors(-1)
			end)

			-- Append/insert for each line of visual selections.
			-- Similar to block selection insertion.
			set("x", "I", mc.insertVisual)
			set("x", "A", mc.appendVisual)

			-- Increment/decrement sequences, treaing all cursors as one sequence.
			set({ "n", "x" }, "g<c-a>", mc.sequenceIncrement)
			set({ "n", "x" }, "g<c-x>", mc.sequenceDecrement)

			-- Add a cursor and jump to the next/previous search result.
			-- set("n", "<leader>/n", function()
			-- 	mc.searchAddCursor(1)
			-- end)
			-- set("n", "<leader>/N", function()
			-- 	mc.searchAddCursor(-1)
			-- end)
			--
			-- -- Jump to the next/previous search result without adding a cursor.
			-- set("n", "<leader>/s", function()
			-- 	mc.searchSkipCursor(1)
			-- end)
			-- set("n", "<leader>/S", function()
			-- 	mc.searchSkipCursor(-1)
			-- end)

			-- Add a cursor to every search result in the buffer.
			-- set("n", "<leader>/A", mc.searchAllAddCursors)

			-- Pressing `<leader>miwap` will create a cursor in every match of the
			-- string captured by `iw` inside range `ap`.
			-- This action is highly customizable, see `:h multicursor-operator`.
			set({ "n", "x" }, "<leader>m", mc.operator)

			-- Add or skip adding a new cursor by matching diagnostics.
			set({ "n", "x" }, "]d", function()
				mc.diagnosticAddCursor(1)
			end)
			set({ "n", "x" }, "[d", function()
				mc.diagnosticAddCursor(-1)
			end)
			set({ "n", "x" }, "]s", function()
				mc.diagnosticSkipCursor(1)
			end)
			set({ "n", "x" }, "[S", function()
				mc.diagnosticSkipCursor(-1)
			end)

			-- Press `mdip` to add a cursor for every error diagnostic in the range `ip`.
			-- set({ "n", "x" }, "md", function()
			-- 	-- See `:h vim.diagnostic.GetOpts`.
			-- 	mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
			-- end)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<M-left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<M-right>", mc.nextCursor)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Customize how cursors look.
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
	{
		"vim-tmux-navigator",
		lazy = false,
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
		after = function() end,
	},
	{
		"nvim-spider",
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
		"arrow.nvim",
		after = function()
			local opts = {
				show_icons = true,
				leader_key = ";", -- Recommended to be a single key
				buffer_leader_key = "m", -- Per Buffer Mappings
			}
			require("arrow").setup(opts)
		end,
	},
	{
		"nvim-treesitter",
		lazy = false,
		after = function()
			---@param buf integer
			---@param language string
			local function treesitter_try_attach(buf, language)
				-- check if parser exists and load it
				if not vim.treesitter.language.add(language) then
					return false
				end
				-- enables syntax highlighting and other treesitter features
				vim.treesitter.start(buf, language)

				-- enables treesitter based folds
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				-- ensure folds are open to begin with
				vim.o.foldlevel = 99

				-- enables treesitter based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				return true
			end

			local installable_parsers = require("nvim-treesitter").get_available()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf, filetype = args.buf, args.match
					local language = vim.treesitter.language.get_lang(filetype)
					if not language then
						return
					end

					if not treesitter_try_attach(buf, language) then
						if vim.tbl_contains(installable_parsers, language) then
							-- not already installed, so try to install them via nvim-treesitter if possible
							require("nvim-treesitter").install(language):await(function()
								treesitter_try_attach(buf, language)
							end)
						end
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter-textobjects",
		auto_enable = true,
		lazy = false,
		before = function(plugin)
			-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		-- after = function(plugin) end,
	},
	{
		"fidget.nvim",
		after = function()
			require("fidget").setup({})
		end,
	},
	{
		"lualine.nvim",
		after = function()
			require("lualine").setup({})
		end,
	},
	{
		"conform.nvim",
		after = function()
			local opts = {
				format_after_save = {
					-- timeout_ms = 2000,
					lsp_format = "fallback",
					-- lsp_format = "never",
				},
				formatters_by_ft = {
					go = { "goimports", "gofumpt" },
					java = { lsp_fallback = false },
					lua = { "stylua" },
					scala = {},
				},
			}
			require("conform").setup(opts)
		end,
	},

	{
		"nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		after = function()
			local clientCapabilities = vim.lsp.protocol.make_client_capabilities()

			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities(clientCapabilities)

			local servers = {

				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = {
								"-.git",
								"-.vscode",
								"-.idea",
								"-.vscode-test",
								"-node_modules",
							},
							semanticTokens = true,
						},
					},
				},
				helm_ls = {
					yamlls = {
						enable = false,
					},
				},
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = "nixfmt",
					},
				},
				pyright = {},
				rust_analyzer = {},
				brichka = {},
			}

			for server, serverOpts in pairs(servers) do
				serverOpts.capabilities = capabilities
				vim.lsp.config(server, serverOpts)
				vim.lsp.enable(server)
			end
		end,
	},
	{
		"nvim-jdtls",
		dependencies = { "mfussenegger/nvim-dap", "neovim/nvim-lspconfig" },
		after = function()
			-- Autocmd
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "java" },
				callback = function()
					local jdtls = require("jdtls")

					local config = {
						cmd = {
							"jdtls",
							string.format(
								"--jvm-arg=-javaagent:%s",
								require(vim.g.nix_info_plugin_name)(nil, "settings", "lombokPath")
							),
							-- string.format("--jvm-arg=-Xbootclasspath/a:%s", vim.g.lombok_path),
						},
						root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
						settings = {
							extendedClientCapabilities = jdtls.extendedClientCapabilities,
							java = {
								implementationsCodeLens = {
									enabled = true,
								},
								referencesCodeLens = {
									enabled = true,
								},
								format = {
									enabled = false,
								},
							},
						},
					}

					jdtls.start_or_attach(config)
				end,
			})
		end,
	},

	{
		"lazydev.nvim",
		ft = "lua", -- only load on lua files
		after = function()
			local opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			}
			require("lazydev").setup(opts)
		end,
	},
	{
		"crates.nvim",
		event = { "BufRead Cargo.toml" },
		after = function()
			local opts = {
				completion = {
					crates = {
						enabled = true,
					},
				},
				lsp = {
					enabled = true,
					actions = true,
					completion = true,
					hover = true,
				},
			}
			require("crates").setup(opts)
		end,
	},

	{
		"nvim-metals",
		ft = { "scala", "sbt" },

		after = function()
			local clientCapabilities = vim.lsp.protocol.make_client_capabilities()

			local blink = require("blink.cmp")
			local capabilities = blink.get_lsp_capabilities(clientCapabilities)

			local metals_config = require("metals").bare_config()
			metals_config.on_attach = function(client, bufnr)
				-- your on_attach function
			end

			metals_config.capabilities = capabilities

			metals_config.settings.metalsBinaryPath = require(vim.g.nix_info_plugin_name)(nil, "settings", "metalsPath")

			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "scala", "sbt" },
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
		keys = {
			{
				"<leader>cw",
				function()
					require("metals").commands()
				end,
				desc = "Metals commands",
			},
		},
	},
	{
		"brichka.nvim",
		after = function()
			local opts = {
				cmd = {
					brichka = "brichka",
				},
				run = {
					init = true,
				},
			}
			require("brichka").setup(opts)
		end,
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
	},
	{
		"folke/noice.nvim",
		event = "DeferredUIEnter",
		after = function()
			local opts = {
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
			}

			require("noice").setup(opts)
		end,
	},
})
