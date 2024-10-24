-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here


vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "docker-compose.yaml" },
  command = "set filetype=yaml.docker-compose",
})


vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "nix" },
  callback = function(event)
    require("otter").activate(nil, true, true, nil)
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "mustache" },
  callback = function()
    if vim.fn.expand("%:e") == "tpl" then
      vim.bo.filetype = "helm"
    end
  end,
})
