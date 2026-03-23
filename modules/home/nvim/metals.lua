-- metals
vim.api.nvim_set_keymap("n", "<leader>ws", "<cmd>lua require'metals'.worksheet_hover()<CR>", {
	noremap = true,
	silent = true,
})

vim.api.nvim_set_keymap("n", "<leader>ad", "<cmd>lua require'metals'.open_all_diagnostics()<CR>", {
	noremap = true,
	silent = true,
})

vim.api.nvim_set_keymap("n", "<leader>ac", ":CodeActionMenu<CR>", {
	noremap = true,
	silent = true,
})

