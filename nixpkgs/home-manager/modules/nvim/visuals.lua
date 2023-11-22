require'lspkind'.init()
-- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = "99999"
vim.opt.list = true

local highlight = {
    "CursorColumn",
    "Whitespace",
}
require("ibl").setup {
    --indent = { highlight = highlight, char = "" },
    --whitespace = {
        --highlight = highlight,
        --remove_blankline_trail = false,
    --},
    --scope = { enabled = false },
}


vim.g.cursorline_timeout = 0
