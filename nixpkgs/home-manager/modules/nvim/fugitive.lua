local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Git
keymap("n", "<leader>gg", ":Git<CR>", opts)
