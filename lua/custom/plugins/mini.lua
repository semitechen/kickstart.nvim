---@module 'lazy'
---@type LazySpec
return {
  'nvim-mini/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup()

    -- Minimal, high-performance statusline
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- Helper to merge theme colors for a seamless statusline
    local function sync_hl()
      local function get_hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
      local dev_bg = get_hl('MiniStatuslineDevinfo').bg
      local file_bg = get_hl('MiniStatuslineFilename').bg

      -- Create seamless versions of diagnostic and git highlights
      local seamless_groups = {
        { name = 'StlError', fg = 'DiagnosticError', bg = dev_bg },
        { name = 'StlWarn', fg = 'DiagnosticWarn', bg = dev_bg },
        { name = 'StlHint', fg = 'DiagnosticHint', bg = dev_bg },
        { name = 'StlAdd', fg = 'GitSignsAdd', bg = dev_bg },
        { name = 'StlMod', fg = 'GitSignsChange', bg = dev_bg },
        { name = 'StlDel', fg = 'GitSignsDelete', bg = dev_bg },
        { name = 'StlDot', fg = 'DiagnosticWarn', bg = file_bg },
      }

      for _, g in ipairs(seamless_groups) do
        local fg = get_hl(g.fg).fg
        vim.api.nvim_set_hl(0, g.name, { fg = fg, bg = g.bg })
      end
    end

    -- Run once and whenever the theme changes
    sync_hl()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = sync_hl })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function() return '%2l:%-2v' end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_fileinfo = function()
      if vim.bo.filetype == '' then return '' end
      return vim.bo.filetype
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      local filename = vim.fn.expand '%:t'
      if filename == '' then filename = '[No Name]' end

      if vim.bo.modified then return filename .. '  %#StlDot#●%#MiniStatuslineFilename#' end

      return filename .. (vim.bo.readonly and ' ' or '')
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_diagnostics = function(args)
      if statusline.is_truncated(args.trunc_width) then return '' end
      local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      local warns = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

      local res = {}
      if errors > 0 then table.insert(res, '%#StlError# ' .. errors .. '%#MiniStatuslineDevinfo#') end
      if warns > 0 then table.insert(res, '%#StlWarn# ' .. warns .. '%#MiniStatuslineDevinfo#') end
      if hints > 0 then table.insert(res, '%#StlHint#󰌵 ' .. hints .. '%#MiniStatuslineDevinfo#') end

      return table.concat(res, ' ')
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_diff = function(args)
      if statusline.is_truncated(args.trunc_width) then return '' end
      local summary = vim.b.gitsigns_status_dict
      if not summary then return '' end

      local res = {}
      if (summary.added or 0) > 0 then table.insert(res, '%#StlAdd# ' .. summary.added .. '%#MiniStatuslineDevinfo#') end
      if (summary.changed or 0) > 0 then table.insert(res, '%#StlMod# ' .. summary.changed .. '%#MiniStatuslineDevinfo#') end
      if (summary.removed or 0) > 0 then table.insert(res, '%#StlDel# ' .. summary.removed .. '%#MiniStatuslineDevinfo#') end

      return table.concat(res, ' ')
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_lsp = function() return '' end
  end,
}
