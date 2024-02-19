{ pkgs, ... }: {
  conform = ''
    -- set formatting shortcut if lsp is not attached
    vim.api.nvim_set_keymap("n", "F", '<cmd>lua require("conform").format({lsp_fallback = true })<CR>', {
        noremap = true,
        silent = true,
    })
    
    require("conform").setup({
    
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    
      formatters_by_ft = {
        python = { "black" },
        lua = { "stylua" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        -- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },

      notify_on_error = true,

      formatters = {
        black = {
          command = "${pkgs.black}/bin/black"
        },
        stylua = {
          command = "${pkgs.stylua}/bin/stylua"
        },
        prettier = {
          command = "${pkgs.nodePackages.prettier}/bin/prettier"
        },
      },
    })
  '';
}
