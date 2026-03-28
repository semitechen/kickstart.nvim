-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<A-m>', ':Neotree focus left<CR>', desc = 'Focus Explorer (Left)', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    -- Style the popup windows (like when you rename or delete a file)
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,

    -- Customize the UI components
    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        indent_size = 2,
        padding = 1,
        -- Adds those little arrows next to folders
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
        -- The next line ensures nvim-web-devicons handles the file icons
        provider = function(icon, node, state)
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name, node.ext)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
      },
      git_status = {
        symbols = {
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
    },

    -- Set default window behavior
    window = {
      position = 'left',
      width = 35,
    },

    filesystem = {
      hijack_netrw_behavior = 'open_default',
      -- Automatically update the tree if you add/delete files outside Neovim
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
