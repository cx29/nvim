local conf = {}

function conf.mason()
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
end
function conf.masonlsp()
	require("mason-lspconfig").setup({
		ensure_installed = {
			-- "lua-ls"
		},
	})
end
function conf.cmp()
	require("luasnip.loaders.from_vscode").lazy_load()
	local cmp = require("cmp")
	cmp.setup({
		mapping = {
			["<Tab>"] = cmp.mapping.select_next_item(),
			["<S-Tab>"] = cmp.mapping.select_prev_item(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
		},
		window = {
			documentation = cmp.config.window.bordered({
				border = "rounded",
				highlight = "NormalFloat",
			}),
			completion = cmp.config.window.bordered({
				border = "single",
				highlight = "NormalFloat",
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		},
	})
end
function conf.lspsaga()
	require("lspsaga").setup({
		symbol_in_winbar = {
			hide_keyword = true,
			folder_level = 0,
		},
		outline = {
			layout = "float",
		},
	})
end

function conf.epo()
	require("epo").setup()
end

return conf
