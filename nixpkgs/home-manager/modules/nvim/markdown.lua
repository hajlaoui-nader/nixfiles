require('glow').setup({
    border = "shadow", 
    pager = true,
    width = 120,
})

vim.cmd [[ 
    autocmd FileType markdown noremap <leader>p :Glow<CR> 
]]