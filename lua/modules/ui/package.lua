local conf=require('modules.ui.config')

packadd({
  'nvimdev/nightsky.vim',
  config=function()
     vim.cmd.colorscheme('nightsky')
   end,
})

packadd({ -- 启动页展示
  'nvimdev/dashboard-nvim',
  event='VimEnter',
  config=conf.dashboard,
  dependencies={'nvim-tree/nvim-web-devicons'},
})

packadd({ --底下状态栏插件
  'nvimdev/whiskyline.nvim',
  -- 'cx29/whiskyline.nvim',
  event='BufEnter */*',
  config=conf.whisky,
  dependencies={'nvim-tree/nvim-web-devicons'},
})

packadd({ --git插件
  'lewis6991/gitsigns.nvim',
  event='BufEnter */*',
  config=conf.gitsigns,
})

packadd({ -- 缩进提示插件
  'nvimdev/indentmini.nvim',
  event='BufEnter */*',
  config=function()
    require('indentmini').setup({})
  end
})
