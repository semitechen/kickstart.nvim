-- ~/.config/nvim/lua/custom/keymaps.lua

-- Normal mode: Move current line up/down
vim.keymap.set('n', 'J', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', 'K', ':m .-2<CR>==', { desc = 'Move line up', silent = true })

-- Visual mode: Move highlighted block up/down and keep it highlighted
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move block down', silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move block up', silent = true })
