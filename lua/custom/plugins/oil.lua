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
    require('oil').setup {
      default_file_explorer = true,

      -- Instantly apply changes (rename/delete/create) on save without asking for confirmation
      skip_confirm_for_simple_edits = true,

      constrain_cursor = 'name',

      delete_to_trash = true,

      win_options = {
        signcolumn = 'yes:2',

        scrolloff = 0,
      },

      columns = {
        'icon',
      },

      keymaps = {
        -- Safe, native double-click handler with smart routing
        ['<2-LeftMouse>'] = {
          desc = 'Double-click: Open file externally or enter directory',
          callback = function()
            -- Force the cursor to instantly snap to the clicked line before acting
            local mousepos = vim.fn.getmousepos()
            if mousepos and mousepos.line > 0 then pcall(vim.api.nvim_win_set_cursor, 0, { mousepos.line, 0 }) end

            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            if not entry then return end

            local target = oil.get_current_dir() .. entry.name

            if entry.type == 'directory' then
              -- If it's a folder, navigate into it natively within Oil
              oil.open(target)
            else
              -- If it's a file, open it with the OS default application
              vim.ui.open(target)
            end
          end,
        },

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

        -- Initialize ripdrag for Wayland/X11 drag-and-drop (not yet tested)
        ['<leader>d'] = {
          desc = 'Drag file (ripdrag)',
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            if not entry or entry.type == 'directory' then return end

            local target = oil.get_current_dir() .. entry.name

            -- Fire and forget the ripdrag process asynchronously
            vim.fn.jobstart({ 'ripdrag', target }, { detach = true })
            vim.notify('Dragging: ' .. entry.name)
          end,
        },
      },
    }

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
