require("trouble").setup({})

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", {
	noremap = true,
	silent = true,
	desc = "Trouble: Toggle",
})

vim.api.nvim_set_keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
	noremap = true,
	silent = true,
	desc = "Buffer Diagnostics",
})

vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {
	noremap = true,
	silent = true,
	desc = "LSP Definitions / references / ... (Trouble)",
})

vim.api.nvim_set_keymap("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {
	noremap = true,
	silent = true,
	desc = "Location List (Trouble)",
})

vim.api.nvim_set_keymap("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {
	noremap = true,
	silent = true,
	desc = "Quickfix List (Trouble)",
})
