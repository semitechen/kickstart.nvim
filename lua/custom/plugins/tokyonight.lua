---@module 'lazy'
---@type LazySpec
return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Load early
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      transparent = true,
      styles = {
        comments = { italic = false },
      },
      on_highlights = function(hl, c)
        local transparent = { bg = 'none', fg = 'none' }
        hl.BufferLineFill = transparent
        hl.BufferLineBackground = transparent
        hl.BufferLineSeparator = transparent
        hl.BufferLineSeparatorVisible = transparent
        hl.BufferLineSeparatorSelected = transparent
        hl.BufferLineTabSeparator = transparent
        hl.BufferLineTabSeparatorSelected = transparent
        hl.BufferLineIndicatorSelected = transparent
        hl.BufferLineIndicatorVisible = transparent
      end,
    }

    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
