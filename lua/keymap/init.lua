require('keymap.remap')
local map=require('core.keymap')
local cmd=map.cmd

map.n({ -- normal模式下快捷键
  -- Lspsaga
  ['[e'] = cmd('Lspsaga diagnostic_jump_next'),
  [']e'] = cmd('Lspsaga diagnostic_jump_prev'),
  ['K'] = cmd('Lspsaga hover_doc'),
  ['ga'] = cmd('Lspsaga code_action'),
  ['gd'] = cmd('Lspsaga peek_definition'),
  ['gp'] = cmd('Lspsaga goto_definition'),
  ['gr'] = cmd('Lspsaga rename'),
  ['gh'] = cmd('Lspsaga finder'),
  ['<Leader>o'] = cmd('Lspsaga outline'),
  ['<Leader>dw'] = cmd('Lspsaga show_workspace_diagnostics'),
  ['<Leader>db'] = cmd('Lspsaga show_buf_diagnostics'),
  -- dbsession
  ['<Leader>ss'] = cmd('SessionSave'),
  ['<Leader>sl'] = cmd('SessionLoad'),
  -- Telescope
  --['<Leader>a'] =cmd('Telescope app'),
  ['<Leader>fa'] =cmd('Telescope live_grep'),
  ['<Leader>fs'] =cmd('Telescope grep_string'),
  ['<Leader>ff'] =cmd('Telescope find_files find_command=rg,--ignore,--hidden,--files'),
  ['<Leader>fg'] =cmd('Telescope git_files'),
  ['<Leader>fw'] =cmd('Telescope grep_string'),
  ['<Leader>fh'] =cmd('Telescope help_tags'),
  --['<Leader>fo'] =cmd('Telescope oldfiles'),
  ['<Leader>gc'] =cmd('Telescope git_commits'),
  ['<Leader>e'] = cmd('Telescope file_browser'),-- 打开文件浏览器
  --['<Leader>fd'] =cmd('Telescope dotfiles'),
  -- flybuf.nvim
  ['<Leader>j'] =cmd('FlyBuf'),
  -- gitsign
  [']g'] =cmd('lua require"gitsigns".next_hunk()<CR>'),
  ['[g'] =cmd('lua require"gitsigns".prev_hunk()<CR>'),
  -- rapid
  ['<Leader>c'] =cmd('Rapid'),
})

-- Netrw lazyload
--local loaded_netrw = false
--map.n('<Leader>e',function() -- 打开文件浏览器
  -- vim.g.netrw_banner=0
  -- vim.g.netrw_winsize=15
  -- vim.g.netrw_browse_split=4
  -- vim.g.netrw_liststyle=3
  -- if not loaded_netrw then
  --   vim.g.loaded_netrwPlugin=nil
  --   vim.cmd.source(vim.env.VIMRUNTIME .. '/plugin/netrwPlugin.vim')
  --   vim.cmd('Vexplore')
  --   loaded_netrw=true
  --   return
  -- end
  -- vim.cmd('Vexplore')

--end)

map.n('<Leader>t',function()
  local tmp_name
  if vim.bo.filetype=='lua' then
    tmp_name='nvim_temp'
  end
  if tmp_name then
    vim.cmd('Template ' .. tmp_name)
    return
  end
  return ':Template'
end,{ expr = true })

-- Lspsaga float_terminal
map.nt('<A-d>',cmd('Lspsaga term_toggle'))

map.nx('ga',cmd('Lspsaga code_action'))

