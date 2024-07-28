return {

  {
    'L3MON4D3/LuaSnip',
    after = "nvim-cmp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
    end
  },
  -- auto completion
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
    },

    opts = function()
      vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
      local cmp = require 'cmp'
      local defaults = require 'cmp.config.default' ()
      local compare = require 'cmp.config.compare'
      local luasnip = require 'luasnip'
      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'treesitter' },
          { name = 'buffer' },
          { name = 'path' },
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        preselect = cmp.PreselectMode.None,
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,    -- we still want offset to be higher to order after 3rd letter
            compare.score,     -- same as above
            compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
            compare.recently_used,
            compare.kind,
            compare.length,
            compare.order,
          },
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      }
    end,
  },

  -- comments
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'windwp/nvim-ts-autotag',
    event = "VeryLazy"
  }

}
