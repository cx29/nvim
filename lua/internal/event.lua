local api=vim.api
local nvim_create_autocmd=api.nvim_create_autocmd
local my_group vim.api.nvim_create_augroup('GlepnirGroup',{})

nvim_create_autocmd('BufWritePre',{--在缓冲区写入之前
  group=my_group,
  pattern={'/tmp/*','COMMIT_EDITMSG','MERG_MSG','*.tmp','*.bak'},
  command='setlocal noundofile', -- 设置本地选项‘noundofile’ 防止文件生成undo文件
})

nvim_create_autocmd('BufRead',{ -- 在缓冲区读取时
  group=my_group,
  pattern='*.conf',
  command='setlocal filetype=conf', -- 设置缓冲区文件类型为conf
})

nvim_create_autocmd('TextYankPost',{ -- 文本复制后
  group=my_group,
  callback=function() -- 当文本被复制，触发高亮效果
    vim.highlight.on_yank({higroup='IncSearch',timeout=400})
  end,
})


nvim_create_autocmd('Filetype',{ -- 关闭以下文件的默认语法高亮，提高大文件加载性能
  group=my_group,
  pattern='*.c,*.cpp,*.lua,*.ts,*.py',
  command = 'syntax off',
})

nvim_create_autocmd('CursorHold',{ --光标暂停时
  group=my_group,
  callback=function(opt) --处理光标停留时的操作
    require('internal.cursorword').cursor_moved(opt.buf)
  end,
})

nvim_create_autocmd('InsertEnter',{ --进入插入模式时
  group=my_group,
  once =true,
  callback=function()
    require('internal.cursorword').disable_cursorword()
  end,
})


nvim_create_autocmd('BufEnter',{ -- 进入缓冲区时加载自定义映射
  group=my_group,
  once=true,
  callback=function()
    require('keymap')
    require('internal.track').setup()
  end,
})
