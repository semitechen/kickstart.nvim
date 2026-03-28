-- ~/.config/nvim/lua/custom/commands.lua

-- Alias :W to :w (Save file)
vim.api.nvim_create_user_command('W', 'w', { desc = 'Save current file' })

-- (Bonus: You can also add :Q to :q so you don't accidentally get stuck when exiting!)
vim.api.nvim_create_user_command('Q', 'q', { desc = 'Quit Neovim' })
vim.api.nvim_create_user_command('Wq', 'wq', { desc = 'Save and Quit' })
vim.api.nvim_create_user_command('WQ', 'wq', { desc = 'Save and Quit' })
