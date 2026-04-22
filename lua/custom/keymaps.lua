-- Normal mode: Move current line up/down
vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "Move line up", silent = true })

-- Visual mode: Move highlighted block up/down and keep it highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Shift left" })
vim.keymap.set("v", ">", ">gv", { desc = "Shift right" })

-- ============================================================================
-- CLIPBOARD & REGISTER MANAGEMENT
-- ============================================================================

-- 1. System Clipboard Integration
-- Use <leader>y to explicitly copy to the Mac system clipboard ("+ register)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Map Cmd+V (<D-v>) to paste from system clipboard
-- Note: This works in GUIs like Neovide or terminals configured to pass Cmd to Neovim.
-- If your terminal intercepts Cmd+V, it will just type the clipboard text natively.
vim.keymap.set({ "n", "v" }, "<D-v>", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard" })
vim.keymap.set("c", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard" })

-- 2. Internal Register Hygiene
-- Prevent pasting over visual selection from replacing the copied text
-- (We delete the selection to the black hole register "_d, then paste P)
vim.keymap.set("x", "p", '"_dP', { desc = "Paste over selection without yanking" })

-- Send minor deletions to the black hole register so they don't pollute the clipboard.
-- This keeps 'd' (cut) and 'y' (yank) as the only operations that affect your internal clipboard.
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line without yanking" })
vim.keymap.set({ "n", "v" }, "s", '"_s', { desc = "Substitute without yanking" })

-- Remap for S-CR to work inside tmux
vim.keymap.set({ "n", "i" }, "<Esc>[13;2u", "<S-CR>", { remap = true })
