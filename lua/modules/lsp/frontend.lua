local lspconfig=require('lspconfig')
local _attach=require('modules.lsp.backend')._attach
local capabilities=require('modules.lsp.backend').capabilities


lspconfig.jsonls.setup({
  on_attach=_attach,
  filetypes={"json"},
  init_options={
    provideFormatter=true
  },
  commands={
    Format={
      function ()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
    }
  }
})

-- lspconfig.tsserver.setup({
--   on_attach=_attach,
--   capabilities=capabilities,
-- })
lspconfig.vuels.setup({
  on_arrach=_attach,
  filetypes={'vue'},
  capabilities=capabilities,
  init_options={
    config={
      css={},
      emmet={},
      html={
        suggest={}
      },
      javascript={
        format={}
      },
      stylusSupremacy={},
      typescript={
        format={}
      },
      vetur={
        completion={
          autoImport=false,
          tagCasing='kebab',
          useScaffoldSnippets=false
        },
        format={
          defaultFormatter={
            js="prettier",
            ts="none"
          },
          defaultFormatterOptions={},
          scriptInitialIndent=false,
          styleInitialIndent=false
        },
        useWorkspaceDependencies=false,
        validation={
          script=true,
          style=true,
          template=true}
      }
    }
  }
})




lspconfig.eslint.setup({
  filetypes={'javascriptreact','typescriptreact'},
  on_attach=function(client,bufnr)
    _attach(client)
    vim.api.nvim_create_autocmd('bufwritepre',{
      buffer=bufnr,
      command='eslintfixall',
    })
  end
})

lspconfig.cssls.setup({
  capabilities=capabilities,
  cmd={"vscode-css-language-server","--stdio"},
  filetypes={"css","scss","less"},
  settings={
    css={
      validate=true
    },
    less={
      validate=true
    },
    scss={
      validate=true
    }
  }
})
lspconfig.html.setup({
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  init_options = {
   configurationSection = { "html", "css", "javascript" },
   embeddedLanguages = {
      css = true,
      javascript = true
    }
  }
})
