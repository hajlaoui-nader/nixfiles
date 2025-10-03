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

    vim.api.nvim_set_keymap('n', '<leader>flsb', "<cmd> Telescope lsp_document_symbols<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>flsw', "<cmd> Telescope lsp_workspace_symbols<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>flr', "<cmd> Telescope lsp_references<CR>", {
        noremap = true,
        silent = true
    });
    
    vim.api.nvim_set_keymap('n', '<leader>fli', "<cmd> Telescope lsp_implementations<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>flD', "<cmd> Telescope lsp_definitions<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>flt', "<cmd> Telescope lsp_type_definitions<CR>", {
        noremap = true,
        silent = true
    });
    vim.api.nvim_set_keymap('n', '<leader>fld', "<cmd> Telescope diagnostics<CR>", {
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
            "--smart-case",
            "--fixed-strings"
          },
        },
        pickers = {
          find_command = {
            "${pkgs.fd}/bin/fd",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
              -- even more opts
            }

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
          }
        }
      }
  '';

}
