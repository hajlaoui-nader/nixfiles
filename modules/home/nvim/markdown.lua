require("render-markdown").setup({})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<leader>rt", ":RenderMarkdown toggle <CR>", { buffer = true })
	end,
})
