return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      filtered_items = {
        hide_dotfiles = false,
      },
    },
    window = {
      mappings = {
        ['<space>'] = 'none',
      },
    },
  },
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute { toggle = true }
      end,
      desc = 'Toggle NeoTree',
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
    }
  },
}
