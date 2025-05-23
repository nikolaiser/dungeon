for option_name, value in pairs {
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  expandtab = true,
  cmdheight = 1,
  mouse = 'a',
  clipboard = 'unnamedplus',
  syntax = 'on',
  relativenumber = true,
  smoothscroll = true,
  foldmethod = "expr",
  foldexpr = "nvim_treesitter#foldexpr()",
  foldenable = false,
  confirm = true,
  cursorline = true,
  fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  },
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  ignorecase = true,
  laststatus = 3,
  linebreak = true,
  pumblend = 10,
  scrolloff = 4,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  spelllang = { "en" },
  splitbelow = true,
  splitkeep = "screen",
  splitright = true,
  termguicolors = true,
  undofile = true,
  undolevels = 10000,
  updatetime = 200,
  wildmode = "longest:full,full",

} do
  vim.opt[option_name] = value
end

vim.g.root_lsp_ignore = { "helm_ls", "jsonls", "yamlls" }
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level
