vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.cmd([[ let g:copilot_no_tab_map = v:true ]])
