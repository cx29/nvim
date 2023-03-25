local opt = vim.opt -- for conciseness

-- line numbers
opt.number = true -- shows absolute line number on cursor line

-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "UTF-8"
-- jkhl 移动时光标周围保留8行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- 行号
opt.relativenumber = true
opt.number = true
-- 边输入边搜索
vim.o.incsearch = true
-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false
-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- 是否显示不可见字符
vim.o.list = false

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight cursorline

-- 启用鼠标
opt.mouse:append("a")

-- appearance
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

vim.g.mkdp_browser = "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\Google Chrome"
