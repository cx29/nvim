local M={}
local lspconfig=require('lspconfig')

M.capabilities=vim.tbl_deep_extend( --定义lsp客户端功能
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('epo').register_cap()
)

function M._attach(client,_) -- lsp客户端连接的时候执行设置
  vim.opt.omnifunc='v:lua.vim.lsp.omnifunc' -- 确保补全功能生效
  client.server_capabilities.semanticTokensProvider=nil
  local orignal=vim.notify
  local mynotify=function(msg,level,opts)
    if msg=='No code actions available' or msg:find('ovrtly') then
      return
    end
    orignal(msg,level,opts)
  end
  vim.notify=mynotify
end


-- lspconfig.gopls.setup({ -- 给go的lsp服务器进行设置 
--   cmd={ 'gopls','serve' },
--   on_attach=M._attach,
--   capabilities=M.capabilities,
--   init_options={
--     usePlaceholders=true,
--     completeUnimported=true,
--   },
--   settings={
--     gopls={
--       analyses={
--         unusedparams=true,
--       },
--       staticcheck=true,
--     }
--   }
-- })


lspconfig.lua_ls.setup({ -- 给lua的lsp服务器进行配置
  on_attach=M._attach,
  capabilities=M.capabilities,
  settings={
    Lua={
      diagnostics={
        enable=true,
        globals={'vim'},
        disable={
          'missing-fields',
          'no-unknown',
        },
      },
      runtime={
        version='LuaJIT',
        path=vim.split(package.path,';'),
      },
      workspace={
        library={
          vim.env.VIMRUNTIME,
        },
        checkThirdParty=false,
      },
      completion={
        callSnippet='Replace',
      }
    }
  }
})

lspconfig.clangd.setup({ -- 配置C语言的lsp服务器
  cmd = { 'clangd', '--background-index' },
  on_attach = M._attach,
  capabilities = M.capabilities,
  root_dir = function(fname)
    return lspconfig.util.root_pattern(unpack({
      --reorder
      'compile_commands.json',
      '.clangd',
      '.clang-tidy',
      '.clang-format',
      'compile_flags.txt',
      'configure.ac', -- AutoTools
    }))(fname) or lspconfig.util.find_git_ancestor(fname)
  end,
})



  local servers = {
  'pyright',
  'bashls',
  'zls',
}

-- lspconfig.pylsp.setup({ settings = { pylsp = { plugins = { pylint = { enabled = true } } } } })

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    on_attach = M._attach,
    capabilities = M.capabilities,
  })
end

vim.lsp.handlers['workspace/diagnostic/refresh']=function(_,_,ctx)
  local ns=vim.lsp.diagnostic.get_namespace(ctx.client_id)
  local bufnr=vim.api.nvim_get_current_buf()
  vim.diagnostic.reset(ns,bufnr)
  return true
end


return M
