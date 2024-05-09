local opt=vim.opt

-- 制表符相关设置
opt.smarttab=true -- 开启自动识别缩进
opt.expandtab=true --将制表符自动转换为对应数量空格
opt.autoindent=true --自动缩进,根据上一行来进行缩进
opt.shiftwidth=2 --自动缩进为两个字符宽度
opt.tabstop=2  -- 制表符设置为2个字符宽度


opt.termguicolors=true -- 启用终端颜色，支持GUI颜色
opt.hidden = true -- 允许在未保存修改的情况下切换缓冲区
opt.magic = true -- 在搜索模式下启用正则表达式
opt.virtualedit= 'block' -- 在普通模式下可以随便移动光标，即使没有字符
opt.clipboard = 'unnamedplus' -- 与系统剪切板共享内容
opt.wildignorecase =true -- 在文件名补全时忽略大小写
opt.swapfile =false -- 禁用交换文件
opt.history = 2000 -- 设置撤销历史为2000步
opt.timeoutlen = 500  -- 设置按键响应超时时间为500毫秒

opt.updatetime=60000 --设置自动保存文件时间间隔为10分钟
opt.cursorline = true -- 显示光标所在行

-- 如果系统安装了ripgrep则进行设置
if vim.fn.executable('rg') == 1 then
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m' -- 解析规则
  opt.grepprg = 'rg --vimgrep --no-heading --smart-case' -- 产生适用于vim的输出格式   
  --不显示rg的头部信息   根据是否包含大写字母来决定是否大小写敏感
end

opt.completeopt='menu,menuone,noinsert' -- 显示补全菜单，如果只有一个匹配项也显示菜单，
--不在插入模式下自动插入第一个匹配项

opt.showmode = false -- 不在命令行显示模式
-- a不显示文件名和目录名的附加信息，o不显示插入模式从‘Ctrl’到‘s'的信息，
-- 0不在命令行右上角显示’recording‘或’replaying‘信息，T在命令行右上角不显示信息，I不显示启动画面，
-- c不在命令行上显示’ins-completion‘ 、 ’dirs‘ 和’wildmenu‘的信息，
-- F不在文件和目录名后面显示文件类型和权限
--opt.shortmess='ao0TIcF' -- 控制信息的显示方式

opt.scrolloff=8 -- 控制光标前后空出的行
opt.sidescrolloff=5 --控制左右空出的列
opt.ruler=false -- 不显示右下角的行号和列号
opt.showtabline = 0 -- 不显示底部的标签栏
opt.winwidth =30 --设置最少列
opt.pumheight =15 --设置弹出菜单最大高度为15行
opt.showcmd =false -- 命令行下方不会显示正在输入的命令
opt.cmdheight=0 -- 完全隐藏命令行
opt.laststatus=3 --设置状态栏的显示方式 3为一直显示
opt.list =true -- 显示可见字符

opt.listchars='tab:»·,nbsp:+,trail:·,extends:→,precedes:←' --配置可见字符的显示方式
opt.pumblend =10 -- 设置菜单的透明度,越大越不透明
opt.winblend=0 -- 设置窗口的透明度 0表示不透明
opt.undofile=true --持久化撤销历史，重新打开文件仍然可以撤销

opt.foldlevelstart = 99 -- 代码折叠的初始级别
-- opt.foldmethod = 'marker' -- 根据代码中设置的折叠标志进行折叠
opt.foldmethod = 'indent' -- 根据代码中设置的折叠进行折叠


opt.splitright = true -- 分割窗口默认在右边  :vsp 可以分割窗口
opt.wrap = false -- 关闭自动换行

opt.number=true -- 显示行号
opt.signcolumn = 'yes' -- 配置代码行旁边的标志列，为yes时显示在行左侧
opt.spelloptions= 'camel' -- 拼写检查，检查驼峰命名法

opt.colorcolumn = '100' -- 在100列时显示颜色列 ，代码规范



--用于版本控制，获取标志的详细信息
local function get_signs()
  local buf = vim.api.nvim_get_current_buf() -- 获取当前缓冲区的句柄
  return vim.tbl_map(function(sign)   -- 对标志进行处理
    return vim.fn.sign_getdefined(sign.name)[1]  --获取定义
  end, vim.fn.sign_getplaced(buf, { group = '*', lnum = vim.v.lnum })[1].signs) -- 获取行上所有标志
end


local function fill_space(count)
  -- 生成一个用于文本着色的字符串
  return '%#StcFill#' .. (' '):rep(count) .. '%*' 
end

vim.g.neoformat_cpp_clangformat={
  exe='clang-format',
  args={'--style=google'},
  stdin=true
}
vim.g.neoformat_enabled_cpp={'clangformat'}
-- vim.g.neoformat_enabled_c={'clangformat'}


function _G.show_stc()   -- 显示行号，标志等信息
  local sign, gitsign
  -- 便利获取标志列表
  for _, s in ipairs(get_signs()) do
    if s.name:find('GitSign') then --如果包含GitSign则为Git标志
      gitsign = '%#' .. s.texthl .. '#' .. s.text .. '%*'
    else
      -- 否则为普通标志
      sign = '%#' .. s.texthl .. '#' .. s.text .. '%*'
    end
  end

  -- 定义显示行号的函数
  local function show_break()
    if vim.v.virtnum > 0 then -- 如果virtnum>0 则显示缩进
      return (' '):rep(math.floor(math.ceil(math.log10(vim.v.lnum))) - 1) .. '↳'
    elseif vim.v.virtnum < 0 then -- <0不显示任何内容
      return ''
    else
      -- 否则显示行号
      return vim.v.lnum
    end
  end

  return (sign and sign or fill_space(2))
    .. '%='
    .. show_break()
    .. (gitsign and gitsign or fill_space(2))
end

-- 调用函数，输出到stc上
vim.opt_local.stc=[[%!v:lua.show_stc()]]


vim.cmd [[
hi WinBar guibg=NONE
hi WinBarNC guibg=NONE
]]
