return {
  "hrsh7th/cmp-nvim-lsp",
  cond = function()
    return require("lazyvim.util").has("nvim-cmp")
  end,
}
