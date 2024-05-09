local helper={}
helper.is_win=package.config:sub(1,1) == '\\' and true or false -- 如果路径分隔符是\则是windows
helper.path_sep=helper.is_win and '\\' or '/' --设置路径分隔符

local log=io.open(vim.fn.expand('./log/.nvim_helper_log.txt'),'w')

-- 将多个路径连接成一个完整的路径
function helper.path_join(...)
  local locale=table.concat({...},helper.path_sep)
  return locale
end

-- 获取数据路径,配置路径
function helper.data_path()
  local cli=require('core.cli')
  if cli.config_path then
    return cli.config_path
  end
  return vim.fn.stdpath('data') -- 如果不存在则使用fn去获取数据和配置路径
end
function helper.config_path()
  local cli=require('core.cli')
  if cli.data_path then
    return cli.data_path
  end
  return vim.fn.stdpath('config')
end

-- 接收一个颜色作为参数,返回转义序列,主要用于创建彩色终端输出
local function get_color(color)
  local tbl={
    black='\027[90m',
    red='\027[91m',
    green='\027[92m',
    yellow='\027[93m',
    blue='\027[94m',
    purple='\027[95m',
    cyan='\027[96m',
    white='\027[97m',
  }
  return tbl[color]
end

-- 打印,并确保只有文字有色彩
local function color_print(color)
  local rgb=get_color(color)
  return function(text)
    print(rgb .. text .. '\027[m')
  end
end
-- 与上类似,返回的是函数
function helper.write(color)
  local rgb=get_color(color)
  return function(text)
    io.write(rgb .. text .. '\027[m')
  end
end

-- 输出成功信息
function helper.success(msg)
  color_print('green')('\t🍻' .. msg .. 'Success !! ')
end
-- 输出错误信息
function helper.error(msg)
  color_print('red')(msg)
end


-- 辅助执行git命令,
function helper.run_git(name,cmd,type)
  local pip = assert(io.popen(cmd .. ' 2>&1'))
  color_print('green')('\t🍻' .. type .. ' '..name)
  local failed =false
  for line in pip:lines() do
    if line:find('fatal') then
      failed=true
    end
    io.write('\t' .. line)
    io.write('\n')
  end

  pip:close() -- 关闭io.popen打开的流
  return failed
end

-- 判断文件是否存在
local function exists(file)
  local ok,_,code=os.rename(file,file) -- 通过尝试对文件重命名来检测文件是否存在
  if not ok then  
    if code == 13 then  -- 13代表文件已存在
      return true
    end
  end
  return ok  -- 文件存在ok=true,文件不存在ok=false
end

-- 检查是否是一个路径结尾是否是一个文件夹
function helper.isdir(path)
  return exists(path .. '/')
end

-- 创建元表,允许helper.green("Green text")这样的方式输出绿色文本
setmetatable(helper,{
  __index =function(_,k)
    return color_print(k)
  end,
})


return helper
