local set_keymap=vim.api.nvim_set_keymap  -- 设置全局键盘映射
local buf_set_keymap=vim.api.nvim_buf_set_keymap  -- 设置缓冲区特定键映射

local buf_map_cache = {} -- 缓存缓冲区键映射表
local function buf_map(buf)  -- buf缓冲区句柄
  local fn = buf_map_cache[buf] -- 尝试从缓存表中获取映射设置函数
  if not fn then 
    function fn(mode,lhs,rhs,opts) -- 若为nil则创建一个fn函数，通过调用buf_set_keymap 来设置
      buf_set_keymap(buf,mode,lhs,rhs,opts)
    end
    buf_map_cache[buf]=fn --将fn存入表中
  end
  return fn
end

-- 用于清空或移除表中特定键对应的值
local function key_nil(tbl,keys)
  for _,key in pairs(keys) do
    tbl[key] =nil
  end
end



local function resolve_mode(key)
  if #key == 0 then --如果key为0，则返回空字符串
    return { '' }
  end

  local modes={}
  for char in key:gmatch('.') do --gmatch逐字符便利输入key
    if not char:find('[!abcilnostvx]') then -- 如果不属于集合中的字符则抛出错误
      error(('invalid mode "%s"'):format(char))
    end
    modes[char]=true
  end

  -- alias a -> :map and b -> :map!
  if modes.a then --如果输入的模式中有a则将其从表中移除，并将‘’添加到模式表中
    modes.a=nil
    modes['']=true
  end
  if modes.b then
    modes.b=nil --如果输入的模式中有b则将其移除，并将！添加到表中
    modes['!']=true
  end
  
  -- convert xs -> :vmap,nvo -> :map, ic -> :map!
  if modes.x and modes.s then  -- 将多余的模式去掉
    modes.v=true
  end
  if modes.n and modes.v and modes.o then
    modes['']=true
  end

  local keys={}
  if modes[''] then
    vim.list_extend(keys,{'n','v','o','x','s'})
  elseif modes.v then
    vim.list_extend(keys,{'x','s'})

  elseif modes.l then
    vim.list_extend(keys,{'!','i','c'})
  elseif modes['!'] then
    vim.list_extend(keys,{'i','c'})
  end

  key_nil(modes,keys)
  return modes
end


-- 合并表
local function merge(t,n)
  if n then
    for k,v in pairs(n) do
      t[k] =v
    end
  end
  return t
end

local function index(self,key)
  assert(type(key)=='string','invalid key')

  if key == 'cmd' then 
    local cmd_fn = function(str)
      return '<cmd>' .. str .. '<CR>'
    end

    rawset(self,key,cmd_fn)
    return cmd_fn
  end

  local modes=resolve_mode(key)

  local function map_fn(arg1,arg2,arg3)
    local opts,maps
    if type(arg1)=='string' and (type(arg2)=='string' or type(arg2)=='function') then
      opts=arg3
      assert(opts==nil or type(opts)=='table','expected table as argument #3')
    elseif type(arg1) =='table' then
      opts,maps=arg2,arg1
      assert(opts==nil or type(opts)=='table','expected table as argument #2')
    else 
      error('expected (string,string|function,table?) or (table,table?)')
    end

    do 
      local opts_copy={}
      merge(opts_copy,rawget(self,'opts'))
      merge(opts_copy,opts)
      opts=opts_copy
    end

    if opts.remap then
      opts.remap=nil
      opts.noremap=true
    elseif opts.noremap==nil then
      opts.noremap=true
    end

    local replace_keycodes=opts.replace_keycodes

    local map
    if not opts.buf then
      map=set_keymap
    else
      map=buf_map(opts.buf)
      opts.buf=nil
    end

    if not maps then
      if type(arg2)=='function' then
        opts.callback=arg2
        arg2=''
        if opts.expr and replace_keycodes == nil then
          opts.replace_keycodes=true
        end
      else
        opts.callback = nil
      end

      for mode in pairs(modes) do
        map(mode,arg1,arg2,opts)
      end
    else
      for lhs,rhs in pairs(maps) do
        if type(rhs)== 'function' then
          opts.callback=rhs
          rhs=''
          if opts.expr and replace_keycodes == nil then
            opts.replace_keycodes=true
          end
        elseif type(rhs) =='string' then
          opts.callback=nil
          if opts.expr and replace_keycodes==nil then
            opts.replace_keycodes=false
          end
        else
          error('expected string or function as rhs')
        end

        for mode in pairs(modes) do
          map(mode,lhs,rhs,opts)
        end
      end
    end
  end
  rawset(self,key,map_fn)
  return map_fn
end



local mt= { __index = index }

local function new(opts)
  assert(opts==nil or type(opts)=='table','expected table')
  return setmetatable({
    opts=opts,
    new=new,
  },mt)
end


local map=new()
return map
