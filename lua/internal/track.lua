local api=vim.api

local MiniComment={}

local H={}

local function default_config()
  return{
    options={
      custom_commentstring=nil,
      ignore_blank_line=false,
      start_of_line=false,
      pad_comment_parts=true,
    },
    mappings={
      comment='gc',
      comment_line='gcc',
      textobject='gc',
    },
    hooks={
      pre=function() end,
      post=function() end,
    }
  }
end

local function map(mode,lhs,rhs,opts)
  if lhs == '' then
    return
  end
  opts=vim.tbl_deep_extend('force',{silent=true}, opts or {})
  vim.keymap.set(mode,lhs,rhs,opts)
end

local function apply_config(config)
  MiniComment.config=config

  map('n',config.mappings.comment,function()
    return MiniComment.operator()
  end,{expr=true,desc='Comment'})
  map('x',
      config.mappings.comment,
      [[:<c-u>lua MiniComment.operator('visual')<cr>]],
      {desc='Comment selection'}
  )
  map('n',config.mappings.comment_line,function()
    return MiniComment.operator() .. '_'
  end,{expr=true,desc='comment line'})

  map(
  'o',
  config.mappings.textobject,
  '<Cmd>lua MiniComment.textobject()<CR>',
  { desc = 'Comment textobject' }
  )
end

local function setup(config)
  _G.MiniComment=MiniComment

  vim.validate({config={config,'table',true}})
  config=vim.tbl_deep_extend('force',default_config(),config or {})
  apply_config(config)
end

local function is_disabled()
  return vim.g.minicomment_disable==true or vim.b.minicomment_disable==true
end


MiniComment.operator=function(mode)
  if is_disabled() then
    return ''
  end

  if mode== nil then
    vim.o.operatorfunc='v:lua.MiniComment.operator'
    return 'g@'
  end

  local mark_left,mark_right='[',']'
  if mode=='visual' then
    mark_left,mark_right='<','>'
  end

  local line_left,col_left=unpack(api.nvim_buf_get_mark(0,mark_left))
  local line_right,col_right=unpack(api.nvim_buf_get_mark(0,mark_right))

  if (line_left>line_right) or (line_left==line_right and col_left >col_right) then
    return
  end

  vim.cmd(string.format(
    [[lockmarks lua MiniComment.toggle_lines(%d,%d,{ ref_position={ vim.fn.line('.'),vim.fn.col('.') } })]],
    line_left,
    line_right
  ))
  return ''

end

MiniComment.toggle_lines=function(line_start,line_end,opts)
  if is_disabled() then
    return
  end

  opts=opts or {}
  local ref_position=opts.ref_position or {line_start,1}

  local n_lines=api.nvim_buf_line_count(0)
  if not (1<=line_start and line_start <= n_lines and 1 <= line_end and line_end <=n_lines) then
    error(
    ('(mini.comment) `line_start` should be less than or equal to `line_end`.')
    )
  end

  if not (line_start <= line_end) then
    error('(mini.comment) `line_start` should be less than or equal to `line_end`.')
  end

  local config=H.get_config()
  if config.hooks.pre()==false then
    return
  end

  local comment_parts=H.make_comment_parts(ref_position)
  local lines=api.nvim_buf_get_lines(0,line_start-1,line_end,false)
  local indent,is_comment=H.get_lines_info(lines,comment_parts,H.get_config().options)

  local f
  if is_comment then
    f=H.make_uncomment_function(comment_parts)
  else
    f=H.make_comment_function(comment_parts,indent)
  end

  for n,l in pairs(lines) do
    lines[n]=f(l)
  end

  api.nvim_buf_set_lines(0,line_start-1,line_end,false,lines)

  if config.hooks.post()==false then
    return
  end
end

MiniComment.textobject=function()
  if is_disabled() then
    return
  end

  local config=H.get_config()
  if config.hooks.pre()==false then
    return
  end

  local comment_parts=H.make_comment_parts({vim.fn.line('.'),vim.fn.col('.')})
  local comment_check=H.make_comment_check(comment_parts)
  local line_cur=api.nvim_win_get_cursor(0)[1]

  if comment_check(vim.fn.getline(line_cur)) then
    local line_start=line_cur
    while (line_start>=2) and comment_check(vim.fn.getline(line_start - 1)) do
      line_start=line_start-1
    end

    local line_end=line_cur
    local n_lines=api.nvim_buf_line_count(0)
    while (line_end<=n_lines -1) and comment_check(vim.fn.getline(line_end+1)) do
      line_end=line_end+1
    end

    vim.cmd(string.format('normal! %dGV%dG',line_start,line_end))
  end
  if config.hooks.post() == false then
    return
  end
end


MiniComment.get_commentstring=function(ref_position)
  local buf_cs=api.nvim_buf_get_option(0,'commentstring')

  local has_ts_parser,ts_parser=pcall(vim.treesitter.get_patser)
  if not has_ts_parser then
    return buf_cs
  end

  local row,col=ref_position[1] -1 ,ref_position[2]-1
  local ref_range={row,col,row,col+1}

  local ts_cs,res_level=nil,0
  local traverse

  traverse = function(lang_tree,level)
    if not lang_tree:contains(ref_range) then
      return
    end

    local lang=lang_tree:lang()
    local filetypes=vim.treesitter.language.get_filetypes(lang)
    for _, ft in ipairs(filetypes) do
      local cur_cs=vim.filetype.get_option(ft,'commentstring')
      if type(cur_cs) == 'string' and cur_cs ~='' and level > res_level then
        ts_cs=cur_cs
      end
    end

    for _,child_lang_tree in pairs(lang_tree:children()) do
      traverse(child_lang_tree,level+1)
    end
  end
  traverse(ts_parser,1)
  return ts_cs or buf_cs
end

H.get_config=function(config)
  return vim.tbl_deep_extend(
    'force',
    MiniComment.config,
    vim.b.minicomment_config or {},
    config or {}
  )
end

local function call_safely(f,...)
  if not vim.is_callable(f) then
    return nil
  end
  return f(...)
end

H.make_comment_parts=function(ref_position)
  local options=H.get_config().options

  local cs=call_safely(options.custom_commentstring,ref_position) 
    or MiniComment.get_commentstring(ref_position)

  if not cs or #cs==0 then
    api.nvim_echo(
      {
        { '(mini.comment)','WarningMsg' }, { [[Option 'commentstring' is empty.]] },
        true,
        {}
      }
    )
    return { left= '',right='' }
  end

  if not (type(cs)=='string' and cs:find('%%s') ~= nil) then
    local msg=vim.inspect(cs) .. " is not a valid 'commentstring'."
    error(string.format('(mini.comment) %s',msg),0)
  end

  local left,right=cs:match('^%s*(.*)%%s(.-)%s*$')

  if options.pad_comment_parts then
    left,right=vim.trim(left),vim.trim(right)
  end

  return { left=left,right=right }
end

H.make_comment_check=function(comment_parts)
  local l,r=comment_parts.left,comment_parts.right

  local start_blank=H.get_config().options.start_of_line and '' or '%s-'
  local regex='^' .. start_blank .. vim.pesc(l) .. '.*' .. vim.pesc(r) .. '%s-$'


  return function(line)
    return line:find(regex)~= nil
  end
end

H.get_lines_info = function(lines,comment_parts,options)
  local n_indent,n_indent_cur=math.huge,math.huge
  local indent,indent_cur

  local is_comment=true
  local comment_check=H.make_comment_check(comment_parts)
  local ignore_blank_line=options.ignore_blank_line

  for _,l in pairs(lines) do
    _,n_indent_cur,indent_cur = l:find('^(%s*)')
    local is_blank=n_indent_cur==l:len()

    if n_indent_cur<n_indent and not is_blank then
      n_indent=n_indent_cur
      indent=indent_cur
    end

    if not (ignore_blank_line and is_blank) then
      is_comment = is_comment and comment_check(l)
    end
  end

  return indent or '', is_comment
end

H.make_comment_function = function(comment_parts,indent)
  local options=H.get_config().options

  local nonindent_start = indent:len()+1

  local l,r=comment_parts.left,comment_parts.right
  local lpad=(options.pad_comment_parts and l ~= '') and ' ' or  ''
  local rpad=(options.pad_comment_parts and r ~= '') and ' ' or  ''

  local blank_comment=indent .. l .. r


  local l_esc,r_esc=l:gsub('%%','%%%%'),r:gsub('%%','%%%%')
  local left=options.start_of_line and (l_esc .. indent) or (indent .. l_esc)
  local nonblank_format=left .. lpad .. '%s' .. rpad .. r_esc
  local ignore_blank_line=options.ignore_blank_line
  return function(line)
    if line:find('^%s*$') ~= nil then
      return ignore_blank_line and line or blank_comment
    end

    return string.format(nonblank_format,line:sub(nonindent_start))
  end
end



H.make_uncomment_function = function(comment_parts)
  local options=H.get_config().options

  local l,r = comment_parts.left,comment_parts.right
  local lpad=(options.pad_comment_parts and l ~= '') and '[ ]?' or ''
  local rpad=(options.pad_comment_parts and r ~= '') and '[ ]?' or ''

  local uncomment_regex=
    string.format('^(%%s*)%s%s(.-)%s%s%%s-$',vim.pesc(l),lpad,rpad,vim.pesc(r))

  return function(line)
    local indent,new_line=string.match(line,uncomment_regex)
    if new_line == nil then
      return line
    end
    if new_line==''then
      indent=''
    end
    return ('%s%s'):format(indent,new_line)
  end
end

return {
  setup=setup,
}



