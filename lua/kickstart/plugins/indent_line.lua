-- Add indentation guides even on blank lines

---@module 'lazy'
---@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  event = { 'BufReadPre', 'BufNewFile' },
  main = 'ibl',
  ---@module 'ibl'
  ---@type ibl.config
  opts = {},
}
