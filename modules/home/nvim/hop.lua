vim.api.nvim_set_keymap("n", "<leader>h", "<cmd> HopPattern<CR>", {
	noremap = true,
	silent = true,
})

require("hop").setup()
