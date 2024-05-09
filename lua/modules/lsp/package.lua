local conf = require("modules.lsp.config")

local function diag_config()
	local t = {
		"Error",
		"Warn",
		"Info",
		"Hint",
	}
	-- for _, type in ipairs(t) do
	--   local hl = 'DiagnosticSign' .. type
	--   vim.fn.sign_define(hl,{ text = '⯈' , texthl=hl,numhl=hl })
	-- end

	vim.diagnostic.config({
		signs = {
			text = { [1] = "e", ["WARN"] = "w", ["HINT"] = "h" },
		},
		severity_sort = true,
		virtual_text = true,
	})

	vim.lsp.set_log_level("OFF")

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("DisableInSpec", { clear = true }),
		pattern = "lua",
		callback = function(opt)
			local fname = vim.api.nvim_buf_get_name(opt.buf)
			if fname:find("%w_spec%.lua") then
				vim.diagnostic.disable(opt.buf)
			end
		end,
	})
end

packadd({
	"neovim/nvim-lspconfig",
	ft = {
		"lua",
		"sh",
		"c",
		"cpp",
		-- 'javascript',
		-- 'javascriptreact',
		-- 'typescript',
		-- 'typescriptreact',
		"json",
		"vue",
	},
	config = function()
		diag_config()
		require("modules.lsp.backend")
		require("modules.lsp.frontend")
	end,
})

packadd({
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	config = conf.lspsaga,
})
packadd({
	"sbdchd/neoformat",
	event = "LspAttach",
})

packadd({
	"nvimdev/epo.nvim",
	-- 'cx29/epo.nvim',
	event = "LspAttach",
	config = conf.epo,
})

packadd({
	"williamboman/mason.nvim",
	event = "BufRead",
	config = conf.mason,
})
packadd({
  "williamboman/mason-lspconfig.nvim",
  event="BufRead",
  config=conf.masonlsp,
})
