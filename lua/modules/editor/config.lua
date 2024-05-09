local config={}

function config.telescope()
  local function telescope_buffer_dir()
    return vim.fn.expand('%:p:h')
  end
  require('telescope').setup({
    defaults={
      prompt_prefix=' ', -- 提示符前缀，默认为空格
      selection_caret = ' ', -- 选择符样式，箭头
      layout_config={ -- 窗口布局
        horizontal={ prompt_position = 'top',results_width = 0.6}, -- 提示符位置以及结果宽度
        vertical={mirror=false}, -- 不镜像
      },
      sorting_strategy='ascending', -- 排序策略为正序
      file_previewer=require('telescope.previewers').vim_buffer_cat.new, 
      grep_previewer=require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer=require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions={
      fzy_native={
        override_generic_sorter=false,
        override_file_sorter=true,
      },
      file_browser={
        theme='dropdown',
        width=0.5,
        height=0.5,
        path='%:p:h',
        hijack_netrw=true,
        cwd=telescope_buffer_dir(),
        respect_gitignore=false,
        hidden=true,
        grouped=true,
        previewer=false,
        initial_mode='normal',
        layout_config={ height = 40 },
      }
    },
  })

  require('telescope').load_extension('fzy_native') -- 更快的模糊匹配
  require('telescope').load_extension('file_browser') -- 文件浏览器 
  --require('telescope').load_extension('dotfiles') -- 用于查找和操作的dotfiles
  --require('telescope').load_extension('app') -- 用于启动和查找应用程序
end


function config.nvim_treesitter()
  vim.opt.foldmethod='expr'
  vim.opt.foldexpr= 'nvim_treesitter#foldexpr()'
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'python',
      'typescript',
      'javascript',
      'bash',
      'css',
      'scss',
      'html',
      'sql',
      'markdown',
      'markdown_inline',
      'json',
      'jsonc',
    },
    auto_install=true,
    sync_install=false,
    highlight = {
      enable=true,
      disable=function(_,buf)
        return vim.api.nvim_buf_line_count(buf) > 3000 -- 超过3000行就禁用高亮
      end,
    },
  })

  vim.api.nvim_create_autocmd('FileType',{
    pattern={'javascriptreact','typescriptreact'},
    callback=function(opt)
      vim.bo[opt.buf].indentexpr='nvim_treesitter#indent()'
    end,
  })
end


return config



