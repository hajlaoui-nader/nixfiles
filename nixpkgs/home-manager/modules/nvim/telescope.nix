{ pkgs, ... }: {
  telescope = ''
    vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd> Telescope find_files<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<C-p>', "<cmd> Telescope find_files<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd> Telescope live_grep<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd> Telescope buffers<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd> Telescope help_tags<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd> Telescope<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fvcw', "<cmd> Telescope git_commits<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fvcb', "<cmd> Telescope git_bcommits<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fvb', "<cmd> Telescope git_branches<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fvs', "<cmd> Telescope git_status<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fvx', "<cmd> Telescope git_stash<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd> Telescope treesitter<CR>", {
        noremap = true,
        silent = true
    });
    
    require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
          },
          pickers = {
            find_command = {
              "${pkgs.fd}/bin/fd",
            },
          },
        }
      }

  '';

}
