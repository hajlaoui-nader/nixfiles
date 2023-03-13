require("trouble").setup {}


vim.api.nvim_set_keymap('n', '<leader>xx', "<cmd>TroubleToggle<CR>", {
        noremap = true,
        silent = true
});

  vim.api.nvim_set_keymap('n', '<leader>lwd', "<cmd>TroubleToggle workspace_diagnostics<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>ld', "<cmd>TroubleToggle document_diagnostics<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>xq', "<cmd>TroubleToggle quickfix<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>xl', "<cmd>TroubleToggle loclist<CR>", {
        noremap = true,
        silent = true
    });
