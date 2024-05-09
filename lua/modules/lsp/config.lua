local conf={}

function conf.mason()
	require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }    
  })
end
function conf.masonlsp()
  require('mason-lspconfig').setup({
    ensure_installed={
      "lua-ls"
    }
  })
end
function conf.lspsaga()
    require('lspsaga').setup({
      symbol_in_winbar={
        hide_keyword=true,
        folder_level = 0,
      },
      outline={
        layout='float',
      },
    })
end

function conf.epo()
    require('epo').setup()
end

return conf
