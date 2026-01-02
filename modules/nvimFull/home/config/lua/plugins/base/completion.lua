return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		-- branch = "main",
		-- build = "nix run .#build-plugin --accept-flake-config",
		opts = {
			keymap = { preset = "enter" },
			appearance = {
				-- sets the fallback highlight groups to nvim-cmp's highlight groups
				-- useful for when your theme doesn't support blink.cmp
				-- will be removed in a future release, assuming themes add support
				-- use_nvim_cmp_as_default = true,
				-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
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
					"lsp",
					"buffer",
					"snippets",
					"path",
				},
				providers = {},
			},
		},
	},
}
