---@module 'lazy'
---@type LazySpec
return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'refractalize/oil-git-status.nvim',
  },
  lazy = false,

  keys = {
    {
      '\\',
      function()
        local oil = require 'oil'
        if vim.bo.filetype == 'oil' then
          vim.g.last_oil_dir = oil.get_current_dir()
          oil.close()
        else
          if vim.g.last_oil_dir then
            oil.open(vim.g.last_oil_dir)
          else
            oil.open()
          end
        end
      end,
      desc = 'Toggle Full Screen Explorer',
    },
  },

  config = function()
    -- 1. Initialize Oil
    require('oil').setup {
      default_file_explorer = true,

      -- Instantly apply changes (rename/delete/create) on save without asking for confirmation
      skip_confirm_for_simple_edits = true,

      -- Open 2 columns on the left for our clean Git dots
      win_options = {
        signcolumn = 'yes:2',
      },

      columns = {
        'icon',
      },

      keymaps = {
        ['<S-CR>'] = {
          desc = 'Open file in background',
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            if not entry then return end

            local dir = oil.get_current_dir()
            local target = dir .. entry.name

            if entry.type == 'directory' then
              oil.open(target)
            else
              -- Load the file into Neovim's memory
              vim.cmd('badd ' .. vim.fn.fnameescape(target))
              -- Force the UI to immediately redraw the top tabline so the new buffer appears
              vim.cmd 'redrawtabline'
              vim.notify('Opened in background: ' .. entry.name)
            end
          end,
        },

        ['<CR>'] = 'actions.select',
        ['<C-l>'] = 'actions.select',
        ['q'] = 'actions.close',
      },
    }

    -- 2. Initialize Git Status with the correct nested table structure
    require('oil-git-status').setup {
      show_ignored = false,
      symbols = {
        -- Status of files added to the staging area
        index = {
          ['!'] = '◌', -- Ignored
          ['?'] = '●', -- Untracked
          [' A'] = '', -- Added
          ['A'] = '', -- Added
          ['C'] = 'C', -- Copied
          ['D'] = '', -- Deleted
          ['M'] = '', -- Modified
          ['R'] = 'R', -- Renamed
          ['T'] = 'T', -- Type changed
          ['U'] = 'U', -- Unmerged
          [' '] = ' ', -- Unmodified
        },
        -- Status of files in the current working directory
        working_tree = {
          ['!'] = '◌',
          ['?'] = '●',
          [' A'] = '',
          ['A'] = '',
          ['C'] = 'C',
          ['D'] = '',
          ['M'] = '',
          ['R'] = 'R',
          ['T'] = 'T',
          ['U'] = 'U',
          [' '] = ' ',
        },
      },
    }
  end,
}

