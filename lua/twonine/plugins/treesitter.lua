-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

-- configure treesitter
treesitter.setup({
  -- enable syntax highlighting
  highlight = {
    enable = true,
  },
  -- enable indentation
  indent = { enable = true, disable = { "python" } },
  -- enable autotagging (w/ nvim-ts-autotag plugin)
  autotag = { enable = true },
  -- 不同括号颜色区分
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  -- ensure these language parsers are installed
  ensure_installed = {
    "cpp",
    "c",
    "rust",
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "markdown",
    "svelte",
    "graphql",
    "lua",
    "vim",
    "dockerfile",
    -- "gitignore",
  },
  -- auto install above language parsers
  auto_install = true,
})
-- 开启 Folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99
