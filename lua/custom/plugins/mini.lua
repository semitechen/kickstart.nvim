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

    local sep_left = ''
    local sep_right = ''

    local colors = {
      blue = '#7aa2f7',
      dark = '#15161e',
      gray = '#3b4261',
      bg = '#16161e',
      fg = '#a9b1d6',
      orange = '#e0af68',
      purple = '#bb9af7',
      red = '#f7768e',
      cyan = '#7dcfff',
    }

    -- Helper to merge theme colors for a seamless statusline
    local function sync_hl()
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.bg, fg = colors.fg })

      local modes = {
        { name = 'Normal', color = colors.blue },
        { name = 'Insert', color = colors.orange },
        { name = 'Visual', color = colors.purple },
        { name = 'Replace', color = colors.red },
        { name = 'Command', color = colors.cyan },
        { name = 'Other', color = colors.blue },
      }

      for _, m in ipairs(modes) do
        local hl_name = 'MiniStatuslineMode' .. m.name
        vim.api.nvim_set_hl(0, hl_name, { fg = colors.dark, bg = m.color, bold = true })
        vim.api.nvim_set_hl(0, hl_name .. 'Ext', { fg = m.color, bg = colors.bg })
        vim.api.nvim_set_hl(0, hl_name .. 'ToDevinfo', { fg = m.color, bg = colors.gray })
        vim.api.nvim_set_hl(0, 'DevinfoTo' .. hl_name, { fg = m.color, bg = colors.gray })
      end

      vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = colors.fg, bg = colors.gray })
      vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfoExt', { fg = colors.gray, bg = colors.bg })

      vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = colors.fg, bg = colors.bg })

      local dev_bg = colors.gray
      local seamless_groups = {
        { name = 'StlError', fg = 'DiagnosticError', bg = dev_bg },
        { name = 'StlWarn', fg = 'DiagnosticWarn', bg = dev_bg },
        { name = 'StlHint', fg = 'DiagnosticHint', bg = dev_bg },
        { name = 'StlAdd', fg = 'GitSignsAdd', bg = dev_bg },
        { name = 'StlMod', fg = 'GitSignsChange', bg = dev_bg },
        { name = 'StlDel', fg = 'GitSignsDelete', bg = dev_bg },
      }

      for _, g in ipairs(seamless_groups) do
        local fg_color = vim.api.nvim_get_hl(0, { name = g.fg, link = false }).fg
        vim.api.nvim_set_hl(0, g.name, { fg = fg_color, bg = g.bg })
      end
    end

    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local mode_str, mode_hl = statusline.section_mode { trunc_width = 120 }
          local git = statusline.section_diff { trunc_width = 75 }
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
          local filename = statusline.section_filename { trunc_width = 140 }
          local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
          local location = statusline.section_location { trunc_width = 75 }
          local search = statusline.section_searchcount { trunc_width = 75 }

          local info_content = (git ~= '' and git or '') .. (diagnostics ~= '' and (' ' .. diagnostics) or '')
          local left_segment = ''
          if mode_str and mode_str ~= '' then
            left_segment = string.format('%%#%sExt#%s%%#%s# %s ', mode_hl, sep_left, mode_hl, mode_str)
            if info_content ~= '' then
              left_segment = left_segment .. string.format('%%#%sToDevinfo#%s%%#MiniStatuslineDevinfo# %s ', mode_hl, sep_right, info_content)
              left_segment = left_segment .. string.format('%%#MiniStatuslineDevinfoExt#%s', sep_right)
            else
              left_segment = left_segment .. string.format('%%#%sExt#%s', mode_hl, sep_right)
            end
          end

          local right_segment = ''
          if location and location ~= '' then
            if fileinfo ~= '' then
              right_segment = string.format('%%#MiniStatuslineDevinfoExt#%s%%#MiniStatuslineDevinfo# %s ', sep_left, fileinfo)
              right_segment = right_segment .. string.format('%%#DevinfoTo%s#%s%%#%s# %s %%#%sExt#%s', mode_hl, sep_left, mode_hl, location, mode_hl, sep_right)
            else
              right_segment = string.format('%%#%sExt#%s%%#%s# %s %%#%sExt#%s', mode_hl, sep_left, mode_hl, location, mode_hl, sep_right)
            end
          end

          return table.concat({
            left_segment,
            '  ',
            '%#MiniStatuslineFilename#',
            filename,
            '%=',
            search,
            '  ',
            right_segment,
          }, '')
        end,
      },
    }

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
