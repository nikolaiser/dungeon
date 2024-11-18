return {
  'saghen/blink.cmp',
  lazy = false,
  dependencies = 'rafamadriz/friendly-snippets',
  branch = "main",
  build = 'nix run .#build-plugin',
  opts = {
    keymap = { preset = 'enter' },
    nerd_font_variant = 'mono',
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    trigger = { signature_help = { enabled = true } },
    -- accept = { auto_brackets = { enabled = true } }
  }
}
