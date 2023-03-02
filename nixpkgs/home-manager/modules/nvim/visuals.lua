require'lspkind'.init()
 -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
 vim.wo.colorcolumn = "99999"
 vim.opt.list = true
--  vim.opt.listchars:append({ eol = "" })
--  vim.opt.listchars:append({ space = "⋅"})
 require("indent_blankline").setup {
    char = "│",
    show_current_context = true,
    show_end_of_line = true,
  }

  vim.g.cursorline_timeout = 0