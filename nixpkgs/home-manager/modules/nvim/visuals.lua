require'lspkind'.init()
vim.wo.colorcolumn = "99999"
vim.opt.list = true

require("ibl").setup {
    --indent = { highlight = highlight, char = "" },
    --whitespace = {
        --highlight = highlight,
        --remove_blankline_trail = false,
    --},
    --scope = { enabled = false },
}

vim.g.cursorline_timeout = 0
