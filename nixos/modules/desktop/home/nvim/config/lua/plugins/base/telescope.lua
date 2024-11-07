return {
  "nvim-telescope/telescope.nvim",
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    -- Basic
    { "<leader> ",  function() require('telescope.builtin').find_files() end },
    { "<leader>/",  function() require('telescope.builtin').live_grep() end },
    { "<leader>sb", function() require('telescope.builtin').buffes() end },
    { "<leader>sq", function() require('telescope.builtin').quickfix() end },
    { "<leader>sj", function() require('telescope.builtin').jumplist() end },
    -- LSP
    { "<leader>cr", function() require('telescope.builtin').lsp_references() end },
    { "<leader>ci", function() require('telescope.builtin').lsp_incoming_calls() end },
    { "<leader>co", function() require('telescope.builtin').lsp_outgoing_calls() end },
    { "gd",         function() require('telescope.builtin').lsp_definitions() end },
    { "gi",         function() require('telescope.builtin').lsp_implementations() end },

  }
}