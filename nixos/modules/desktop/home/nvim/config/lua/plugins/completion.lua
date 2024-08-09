return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },
    opts = {
      sources = require('cmp').config.sources {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'treesitter' },
        { name = 'buffer' },
        { name = 'path' },
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          require('cmp.config.compare').offset,      -- we still want offset to be higher to order after 3rd letter
          require('cmp.config.compare').score,       -- same as above
          require('cmp.config.compare').sort_text,   -- add higher precedence for sort_text, it must be above `kind`
          require('cmp.config.compare').recently_used,
          require('cmp.config.compare').kind,
          require('cmp.config.compare').length,
          require('cmp.config.compare').order,
        },
      },
    }
  }
}
