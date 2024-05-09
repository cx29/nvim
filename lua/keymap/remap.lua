local map=require('core.keymap')
local cmd= map.cmd

-- normal mode
map.n({
  ['j'] = 'gj',
  ['k']='gk',
  ['<C-s>'] =cmd('write'),
  ['<C-x>k']=cmd('bdelete'),
  ['<C-n>']=cmd('bn'),
  ['<C-p>']=cmd('bp'),
  ['<C-q>']=cmd('qa!'),
  -- window,分裂窗格
  ['<C-h>']='<C-w>h',
  ['<C-l>']='<C-w>l',
  ['<C-j>']='<C-w>j',
  ['<C-k>']='<C-w>k',
  ['<A-[>']=cmd('vertical resize -5'), -- 水平减5
  ['<A-]>']=cmd('vertical resize +5'), -- 水平加5
})


-- Insert mode
map.i({
  ['<C-d>']='<C-o>diw',
  ['<C-h>']='<Left>',
  ['<C-l>']='<Right>',
  ['<C-a>']='<Esc>^i',
  ['<C-k>']='<C-o>d$',
  ['<C-s>']='<Esc>:w<CR>',
  -- move currentline up or down
  ['<A-j>']='<Esc>:m .+1<CR>==gi',-- down
  ['<A-k>']='<Esc>:m .-2<CR>==gi',-- up
})


-- Command mode
map.c({
  ['<C-h>']='<Left>',
  ['<C-l>']='<Right>',
  ['<C-a>']='<Home>',
  ['<C-e>']='<End>',
})

-- Terminal mode
map.t('<Esc>',[[<C-\><C-n>]])
