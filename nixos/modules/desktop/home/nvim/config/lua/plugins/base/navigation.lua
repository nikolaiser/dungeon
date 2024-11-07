return {
	{
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
},
  {
    "nikolaiser/vim-tmux-navigator-sturdy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-Left>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-Down>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-Up>",    "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-Right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>",    "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

}
