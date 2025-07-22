{ pkgs, ... }: {
  conform = ''
    -- set formatting shortcut if lsp is not attached
    vim.api.nvim_set_keymap("n", "<leader>lf", '<cmd>lua require("conform").format({lsp_fallback = true })<CR>', {
        noremap = true,
        silent = true,
    })

    require("conform").setup({

      format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,

      formatters_by_ft = {
        python = { "ruff" },
        lua = { "stylua" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        nix = { "nixpkgs-fmt" },
        -- Use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },

      notify_on_error = true,

      formatters = {
        ruff = {
          command = "${pkgs.ruff}/bin/ruff",
          args = { "format", "--stdin-filename", "$FILENAME" },
          stdin = true,
        },
        stylua = {
          command = "${pkgs.stylua}/bin/stylua"
        },
        prettier = {
          command = "${pkgs.nodePackages.prettier}/bin/prettier"
        },
        ["nixpkgs-fmt"] = {
          command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"
        },
      },
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  '';
}
