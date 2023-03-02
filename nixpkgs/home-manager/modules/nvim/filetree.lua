vim.api.nvim_set_keymap('n', '<C-F>', ":NvimTreeToggle<CR>", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<C-s>', ":NvimTreeFindFile<CR>", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<leader>tr', ":NvimTreeRefresh<CR>", {
    noremap = true,
    silent = true
});

require'nvim-tree'.setup({
    disable_netrw = false,
    hijack_netrw = true,
    open_on_tab = false,
    open_on_setup = true,
    diagnostics = {
        enable = true
    },
    view = {
        width = 25,
        side = 'left'
    },
    renderer = {
        add_trailing = true,
        group_empty = true,
        indent_markers = {
            enable = true
        }
    },
    actions = {
        open_file = {
            quit_on_open = false,
            resize_window = false
        }
    },
    git = {
        enable = true,
        ignore = false
    },
    filters = {
        dotfiles = false 
    }
})