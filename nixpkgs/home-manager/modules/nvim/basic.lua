local g = vim.g
local o = vim.o

-- disable netrw at the very start of your init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- leader
g.mapleader = " "
g.localmapleader = " "

o.number = true
o.relativenumber = true
o.updatetime = 300
o.mouse = "v"
o.swapfile = false
o.termguicolors = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.cmdheight = 2
o.clipboard = "unnamedplus"
o.smartindent = true
o.hidden = true
o.autoindent = true
o.expandtab = true
o.syntax = "on"

vim.api.nvim_set_keymap('n', '<space>', "<nop>", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<C-z>', ":nohlsearch<CR>", {
    noremap = true,
    silent = true
});

-- window actions with Meta instead of <C-w>
-- switching
vim.api.nvim_set_keymap('n', '<M-h>', "<C-w>h", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-j>', "<C-w>j", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-k>', "<C-w>k", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-l>', "<C-w>l", {
    noremap = true,
    silent = true
});

-- moving
vim.api.nvim_set_keymap('n', '<M-H>', "<C-w>H", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-J>', "<C-w>J", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-K>', "<C-w>K", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-L>', "<C-w>L", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-x>', "<C-w>x", {
    noremap = true,
    silent = true
});
-- resizing
vim.api.nvim_set_keymap('n', '<M-<>', "<C-w><", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M->>', "<C-w>>", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-+>', "<C-w>+", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-->', "<C-w>-", {
    noremap = true,
    silent = true
});

vim.api.nvim_set_keymap('n', '<M-=>', "<C-w>=", {
    noremap = true,
    silent = true
});
