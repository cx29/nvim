" For IDE
" 减少判断指令的时间
set timeoutlen=300
" vim基础设置
" 高亮行
set cul
" 高亮列
set cuc
set nu
set rnu

" 将leader键映射为空格
let mapleader = " "
" 连续输入jj退出insert
inoremap jj <Esc>
" 输入模式下移动光标
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" 输入模式下向前后删除东西
" inoremap <A-h> <BS>
" inoremap <A-l> <Del>
