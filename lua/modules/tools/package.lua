local conf=require('modules.tools.config')

packadd({
  'nvimdev/flybuf.nvim', -- 在浮动窗口中显示所有缓冲区列表
  cmd='FlyBuf',
  config=function()
    require('flybuf').setup({})
  end
})

packadd({
  'nvimdev/template.nvim', -- 模板文件的创建和管理
  dev=true,
  cmd='Template',
  config=conf.template_nvim,
})

packadd({
  'nvimdev/guard.nvim', -- 代码格式化和风格检查
  dev=true,
  ft={'c','cpp','lua','typescript','javascript','javascriptreact'},
--  config=conf.guard,
  dependencies={
    {'nvimdev/guard-collection'}
  }
})

packadd({
  'norcalli/nvim-colorizer.lua', -- 将颜色代码直观的展示为颜色
  ft={'lua','css','html','sass','less','typescriptreact','conf','vim'},
  config=function()
    require('colorizer').setup()
  end
})


packadd({
  'nvimdev/dyninput.nvim', -- 动态输入增强工具
  dev=true,
  ft={'c','cpp','lua'},
 -- config=conf.dyninput,
})

packadd({
  'nvimdev/hlsearch.nvim', -- 搜索高亮匹配项
  event='BufRead',
  config=true,
})

packadd({
  'nvimdev/dbsession.nvim', -- 保存，加载和删除会话信息
  cmd={'SessionSave','SessionLoad','SessionDelete'},
  opts=true,
})

packadd({
  'git@github.com:nvimdev/rapid.nvim', -- 快速编辑和导航代码
  cmd='Rapid',
  config=function()
    require('rapid').setup()
  end
})
