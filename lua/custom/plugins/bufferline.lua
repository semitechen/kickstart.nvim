---@module 'lazy'
---@type LazySpec
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',

  lazy = false,

  keys = {
    { '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Previous tab' },
    { '<A-.>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next tab' },
  },

  config = function()
    require('bufferline').setup {
      options = {
        always_show_bufferline = true,
        separator_style = { '', '' },
        indicator = {
          style = 'none',
        },
      },
    }
  end,
}
