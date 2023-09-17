-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  -- 如果存在懒按键处理器就不要创建按键映射？
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

map("i", "jk", "<ESC>")

-- Select all
map("n", "<C-a>", "gg<S-v>G")

map("n", "w", ":w<CR>")
map("n", "wq", ":wq<CR>")
map("n", "qq", ":qa!<CR>")
