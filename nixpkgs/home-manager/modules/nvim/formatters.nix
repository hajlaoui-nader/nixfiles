{ pkgs, ... }: {
  conform = ''
    require("conform").setup({
    
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    
      formatters_by_ft = {
        python = { "black" },
        lua = { "stylua" },
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
      },
    })
  '';
}
