-- 定义全局变量
local g,api=vim.g,vim.api


-- 关闭不必要功能,设置为非0值则禁用
g.loaded_gzip=1
g.loaded_tar=1
g.loaded_tarPlugin=1
g.loaded_zip=1
g.loaded_zipPlugin=1
g.loaded_getscript=1
g.loaded_getscriptPlugin=1
g.loaded_vimball=1
g.loaded_vimballPlugin=1
g.loaded_matchit=1
g.loaded_matchitparen=1
g.loaded_2html_plugin=1
g.loaded_logiPat=1
g.loaded_rrhelper=1
g.loaded_netrwPlugin=1

g.mapleader=' '-- 设置leader键为空格

-- Default KeyMap Setting
-- noremap ====> no recursive mapping 不递归映射
api.nvim_set_keymap('i','jk','<ESC>',{noremap=true})
api.nvim_set_keymap('n','w',':w<CR>',{noremap=true})
api.nvim_set_keymap('n','qq',':q!<CR>',{noremap=true})
api.nvim_set_keymap('n',' ','',{noremap=true}) --normal模式下,空格不起作用
api.nvim_set_keymap('x',' ','',{noremap=true}) --visual模式下,空格不起作用
api.nvim_set_keymap('n','+','<C-a>',{noremap=true}) 
api.nvim_set_keymap('n','-','<C-x>',{noremap=true}) 


require('core.pack'):boot_strap()
require('core.options')
require('internal.event')

