-- 定义变量
-- 分别是文件操作,neovim的api,vim脚本函数
local uv,api,fn=vim.loop,vim.api,vim.fn

local pack = {} -- 空表格,以便后面存入组织相关函数

local OS="" -- 判断系统
local separator="" --分隔符

-- self 相当于this

-- local log=io.open(vim.fn.expand('./log/.nvim_pack_log.txt'),'a')

-- 加载包
function pack:load_modules_packages(curOS)
  local modules_dir=self.helper.path_join(self.config_path,'lua','modules') --获取包目录
  self.repos={} --存储加载的包

  -- list 中的路径分隔符是unix模式，在windows下则为\
  local list=vim.fs.find('package.lua',{path=modules_dir,type='file',limit=10})

  -- 如果为空则直接返回了
  if #list==0 then
    return
  end

  -- 判断一下是否为windows系统
  if curOS == 'win' then
    local updateList={}	  
    for _,file in pairs(list) do
      local updateFilePath=string.gsub(file,'/','\\')
      table.insert(updateList,updateFilePath)
    end
    list = updateList
  end

  -- 遍历list中的文件路径,检查是否需要禁用,不需要禁用则require
  for _,f in pairs(list) do
    local _,pos=f:find(modules_dir)
    f=f:sub(pos-6,#f-4)
    require(f)
  end
end


-- 初始化
function pack:boot_strap()
  self.helper=require('core.helper') -- 导入helper,辅助执行初始化
  self.data_path=self.helper.data_path() -- 获取数据路径
  self.config_path=self.helper.config_path() -- 获取配置路径
  local lazy_path=self.helper.path_join(self.data_path,'lazy','lazy.nvim') --构建lazy_path,归属于data_path下的lazy目录下
  local state=uv.fs_stat(lazy_path) -- 查找是否存在
  if not state then -- 如果不存在则执行拉取lazy.nvim
    local cmd='!git clone git@github.com:folke/lazy.nvim ' .. lazy_path
    api.nvim_command(cmd) -- 执行命令
  end
  vim.opt.runtimepath:prepend(lazy_path) -- 将lazy.nvim添加到运行时路径,便于Neovim加载
  local lazy=require('lazy')
  local opts={
    lockfile=self.helper.path_join(self.data_path,'lazy-lock.json'),
    --dev={path='~/workspace'},
    git={ url_format = 'git@github.com:%s.git' } -- 使用ssh链接进行下载
  }
  OS=self.helper.is_win and 'win' or 'unix'
  separator=self.helper.path_sep
  self:load_modules_packages(OS)
  lazy.setup(self.repos,opts)
  -- 清除自身属性
  for k,v in pairs(self) do
    if type(v) ~='function' then -- ~=是不等于
      self[k]=nil
    end
  end
end

-- 用户添加插件的仓库信息到pack.repos表格中
_G.packadd=function(repo)
  if not pack.repos then
    pack.repos={}
  end
  table.insert(pack.repos,repo)
  --for f in pairs(pack.repos) do
  -- log_file:write(f .. '\n')
  -- log_file:flush()
  --end
end

--执行FileType自动命令 
_G.exec_filetype=function(group)
  group=type(group)=='string' and { group } or group
  local curbuf =api.nvim_get_current_buf()
  for _,g in ipairs(group) do 
    api.nvim_exec_autocmds('Filetype',{ group = g,pattern = vim.bo[curbuf].filetype})
  end
end

-- 执行关闭文件的操作
vim.cmd("autocmd VimLeave * lua log_file:close()")

return pack
--log_file:close()
