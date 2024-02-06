{ pkgs, ... }: {
  lsp = ''
    -- Enable trouble diagnostics viewer
    require'nvim-lightbulb'.setup()

    require("lsp_signature").setup()
    
    vim.cmd [[
      augroup RustMappings
      autocmd!
      autocmd FileType rust lua SetupRustMappings()
      augroup END
    ]]

    function SetupRustMappings()
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap('n', '<leader>ri', '<cmd>lua require("rust-tools.inlay_hints").toggle_inlay_hints()<CR>', opts)
        vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>lua require("rust-tools.runnables").runnables()<CR>', opts)
        vim.api.nvim_set_keymap('n', '<leader>re', '<cmd>lua require("rust-tools.expand_macro").expand_macro()<CR>', opts)
        vim.api.nvim_set_keymap('n', '<leader>rc', '<cmd>lua require("rust-tools.open_cargo_toml").open_cargo_toml()<CR>', opts)
        vim.api.nvim_set_keymap('n', '<leader>rg', "<cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>", opts)
    end

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
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'F', '<cmd>lua require("conform").format({lsp_fallback = true })<CR>', opts)

        -- Metals specific
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmc', '<cmd>lua require("metals").commands()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmi', '<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>', opts)
    end
    
    
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

      -- Enable lspconfig
      local lspconfig = require('lspconfig')

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
       -- Rust config

        local rustopts = {
          tools = {
            autoSetHints = true,
            hover_with_actions = false,
            inlay_hints = {
              only_current_line = false,
            }
          },
          server = {
            capabilities = capabilities,
            on_attach = default_on_attach,
            cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
            settings = {
              ["rust-analyzer"] = {
            experimental = {
              procAttrMacros = true,
            },
          },
            }
          }
        }

        require('crates').setup {
        }

        require('rust-tools').setup(rustopts)

        default_on_attach_python = function(client, bufnr)
            attach_keymaps(client, bufnr)
            format_callback_python(client, bufnr)
        end

        format_callback_python = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = augroup,
                buffer = bufnr,
              })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({bufnr = bufnr})
                  end
              })
          end
        end

        -- Python config
      lspconfig.pyright.setup{
        capabilities = capabilities;
        on_attach=default_on_attach_python;
        cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"};
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
            typeCheckingMode = "off",
          }
        }
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

      -- Scala nvim-metals config
      metals_config = require('metals').bare_config()
      metals_config.capabilities = capabilities
      metals_config.on_attach = default_on_attach

      metals_config.settings = {
          metalsBinaryPath = "${pkgs.metals}/bin/metals",
          showImplicitArguments = true,
          showImplicitConversionsAndClasses = true,
          showInferredType = true,
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

      -- TS config
      lspconfig.tsserver.setup {
          capabilities = capabilities;
          on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end,
          cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
        }
  '';
}
