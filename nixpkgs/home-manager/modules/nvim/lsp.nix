{ pkgs, ... }: {
  lsp = ''
    -- Enable trouble diagnostics viewer
    require'nvim-lightbulb'.setup()

    require("lsp_signature").setup()

    --------------- lsp ----------------
    vim.api.nvim_set_keymap('n', '<leader>d', "<cmd> lua require\"telescope\".extensions.metals.commands()<CR>", {
        noremap = true,
        silent = true
    });

    -- metals
    vim.api.nvim_set_keymap('n', '<leader>ws', "<cmd>lua require'metals'.worksheet_hover()<CR>", {
        noremap = true,
        silent = true
    });

    vim.api.nvim_set_keymap('n', '<leader>a', "<cmd>lua require'metals'.open_all_diagnostics()<CR>", {
        noremap = true,
        silent = true
    });

    vim.cmd [[ 
        autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
    ]]

    local attach_keymaps = function(client, bufnr)
        local opts = {
            noremap = true,
            silent = true
        }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

        -- Alternative keybinding for code actions for when code-action-menu does not work as expected.
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl',
            '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

        -- Metals specific
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmc', '<cmd>lua require("metals").commands()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmi', '<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>', opts)
    end

    local null_ls = require("null-ls")
    local null_helpers = require("null-ls.helpers")
    local null_methods = require("null-ls.methods")

    local ls_sources = {
      null_ls.builtins.formatting.black.with({
          command = "${pkgs.black}/bin/black",
      }),
      null_helpers.make_builtin({
        method = null_methods.internal.FORMATTING,
        filetypes = { "sql" },
        generator_opts = {
          to_stdin = true,
          ignore_stderr = true,
          suppress_errors = true,
          command = "${pkgs.sqlfluff}/bin/sqlfluff",
          args = {
            "fix",
            "-",
          },
        },
        factory = null_helpers.formatter_factory,
      }),
      null_ls.builtins.diagnostics.sqlfluff.with({
        command = "${pkgs.sqlfluff}/bin/sqlfluff",
        extra_args = {"--dialect", "postgres"}
      }),
    }

    vim.g.formatsave = "true"

    -- Enable formatting
    format_callback = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if vim.g.formatsave then
                    local params = require'vim.lsp.util'.make_formatting_params({})
                    client.request('textDocument/formatting', params, nil, bufnr)
                end
            end
        })
    end

    default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        format_callback(client, bufnr)
    end

    -- Enable null-ls
    require('null-ls').setup({
        diagnostics_format = "[#{m}] #{s} (#{c})",
        debounce = 250,
        default_timeout = 5000,
        sources = ls_sources,
        on_attach=default_on_attach
      })

      -- Enable lspconfig
      local lspconfig = require('lspconfig')

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Python config
      lspconfig.pyright.setup{
        capabilities = capabilities;
        on_attach=default_on_attach;
        cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
      }

       -- Nix config
        lspconfig.nil_ls.setup{
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          settings = {
            ['nil'] = {
              formatting = {
                command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
              },
              diagnostics = {
                ignored = { "uri_literal" },
                excludedFiles = { }
              }
            }
          };
          cmd = {"${pkgs.nil}/bin/nil"}
        }

      -- SQLS config
      lspconfig.sqls.setup {
        on_attach = function(client)
          client.server_capabilities.execute_command = true
          on_attach_keymaps(client, bufnr)
          require'sqls'.setup{}
        end,
        cmd = {"${pkgs.sqls}/bin/sqls", "-config", string.format("%s/config.yml", vim.fn.getcwd()) }
      }

      -- Scala nvim-metals config
      metals_config = require('metals').bare_config()
      metals_config.capabilities = capabilities
      metals_config.on_attach = default_on_attach

      metals_config.settings = {
          metalsBinaryPath = "${pkgs.metals}/bin/metals",
          showImplicitArguments = true,
          excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
          }
      }

      metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            prefix = '',
          }
        }
      )

      -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
      vim.opt_global.shortmess:remove("F")

      vim.cmd([[augroup lsp]])
      vim.cmd([[autocmd!]])
      vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
      vim.cmd([[augroup end]])

      -- Nix formatter
      null_ls.builtins.formatting.alejandra.with({
        command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
      });
  '';
}

## TODO ADD THIS when ufo
# capabilities.textDocument.foldingRange = {
#         dynamicRegistration = false,
#         lineFoldingOnly = true
#       }

#       -- Display number of folded lines
#       local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
#         local newVirtText = {}
#         local suffix = ('  %d '):format(endLnum - lnum)
#         local sufWidth = vim.fn.strdisplaywidth(suffix)
#         local targetWidth = width - sufWidth
#         local curWidth = 0
#         for _, chunk in ipairs(virtText) do
#           local chunkText = chunk[1]
#           local chunkWidth = vim.fn.strdisplaywidth(chunkText)
#           if targetWidth > curWidth + chunkWidth then
#             table.insert(newVirtText, chunk)
#           else
#               chunkText = truncate(chunkText, targetWidth - curWidth)
#               local hlGroup = chunk[2]
#               table.insert(newVirtText, {chunkText, hlGroup})
#               chunkWidth = vim.fn.strdisplaywidth(chunkText)
#               -- str width returned from truncate() may less than 2nd argument, need padding
#               if curWidth + chunkWidth < targetWidth then
#                 suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
#               end
#               break
#           end
#           curWidth = curWidth + chunkWidth
#         end
#         table.insert(newVirtText, {suffix, 'MoreMsg'})
#         return newVirtText
#       end

#       require('ufo').setup({
#          fold_virt_text_handler = ufo_handler
#       })

#       -- Using ufo provider needs a large value
#       vim.o.foldlevel = 99 
#       vim.o.foldlevelstart = 99
#       vim.o.foldenable = true

#       -- Using ufo provider need remap `zR` and `zM`
#       vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
#       vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
#       vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
#       vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)

#       capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

#  --------------- lsp saga ----------------
#     -- Enable lspsaga
#     local saga = require 'lspsaga'
#     saga.init_lsp_saga()

#     vim.api.nvim_set_keymap('n', '<leader>lf', "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>lh', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>lr', "<cmd>lua require'lspsaga.rename'.rename()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>ll', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>lc', "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>lp', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>ln', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>ca', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>ls', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", {
#         noremap = true,
#         silent = true
#     });

#     vim.api.nvim_set_keymap('n', '<leader>ac', ":CodeActionMenu<CR>", {
#         noremap = true,
#         silent = true
#     });
