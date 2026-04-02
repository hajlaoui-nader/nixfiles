local paths = require("nix-paths")

require('glow').setup({
  border = "shadow",
  glow_path = paths.glow,
  pager = false,
  width = 120,
})

vim.cmd [[
    autocmd FileType markdown noremap <leader>p :Glow<CR>
  ]]
