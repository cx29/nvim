local config={}

function config.template_nvim()
  require('template').setup({
    temp_dir='~/.config/nvim/template',
    author='tn',
    email='gcx2979@gamil.com',
  })
  require('telescope').load_extension('find_template')
end

function config.guard() -- 不同的语言使用不同的格式化
  local ft = require('guard.filetype')
  ft('c'):fmt({
    cmd='clang-format',
    stdin=true,
    ignore_patterns={'neovim','vim'},
  })

  ft('lua'):fmt({
    cmd='stylua',
    args={'-'},
    stdin = true,
    ignore_patterns='%w_spec%.lua',
  })
  ft('typescript','javascript','typescriptreact','javascriptreact'):fmt('prettier')

  require('guard').setup() -- 代码风格化检查插件
end

function config.dyninput() -- 动态输入增强
  local ms=require('dyninput.lang.misc')
  require('dyninput').setup({
    c={
      ['-']={'->',ms.is_pointer},
    },
    cpp={
      [',']={'<!>',ms.generic_in_cpp},
      ['-']={'->',ms.is_pointer},
    },
    lua={
      [';']={':',ms.semicolon_in_lua},
    },
  })
end

return config
