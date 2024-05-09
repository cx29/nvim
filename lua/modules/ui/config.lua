local config = {}

function config.whisky()
  require('whiskyline').setup() -- 默认
end

function config.dashboard()
  local db = require('dashboard')
  db.setup({
    theme = 'hyper',
    config = {
      week_header = { --启用星期头部
        enable = true,
      },
      project = { -- 启用项目头部
        enable = true,
      },
      disable_move = true,  -- 禁用页面移动
      shortcut = { -- 快捷操作 
        {
          desc = 'Update',
          icon = ' ',
          group = 'Include',
          action = 'Lazy update',
          key = 'u',
        },
        {
          icon = ' ',
          desc = 'Files',
          group = 'Function',
          action = 'Telescope find_files find_command=rg,--ignore,--hidden,--files',
          key = 'f',
        },
        -- {
        --   icon = ' ',
        --   desc = 'Apps',
        --   group = 'String',
        --   action = 'Telescope app',
        --   key = 'a',
        -- },
        -- {
        --   icon = ' ',
        --   desc = 'dotfiles',
        --   group = 'Constant',
        --   action = 'Telescope dotfiles',
        --   key = 'd',
        -- },
      },
    },
  })
end

function config.gitsigns()
  require('gitsigns').setup({
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┃' },
    },
  })
end

return config

