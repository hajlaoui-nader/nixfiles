{ pkgs, ... }: {
  lsp = ''
        -- Enable trouble diagnostics viewer
        require("nvim-lightbulb").setup(
          {
            autocmd = { enabled = true }
          }
        )

        -- lsp signature: hints as you type
        require("lsp_signature").setup()

        vim.cmd [[
          augroup RustMappings
          autocmd!
          autocmd FileType rust lua SetupRustMappings()
          augroup END
        ]]

        function SetupRustMappings()
            local opts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>RustLsp runnables<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>re', '<cmd>RustLsp expandMacro<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>rc', '<cmd>RustLsp openCargo<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>rd', '<cmd>RustLsp debuggables<CR>', opts)
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
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lca', '<cmd>lua require("actions-preview").code_actions()<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl',
        '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lf', '<cmd>lua require("conform").format({lsp_fallback = true })<CR>', opts)

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

          local capabilities = vim.lsp.protocol.make_client_capabilities()

          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
           -- Rust config

            vim.g.rustaceanvim = {
              server = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                  attach_keymaps(client, bufnr)
                  format_callback(client, bufnr)
                end,
                cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
                default_settings = {
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
                vim.lsp.config['pyright'] = {
                  capabilities = capabilities,
                  on_attach = default_on_attach_python,
                  cmd = {"${pkgs.pyright}/bin/pyright-langserver", "--stdio"},
                  filetypes = { 'python' },
                  settings = {
                    python = {
                      analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                        typeCheckingMode = "off",
                      }
                    }
                  }
                }
                vim.lsp.enable('pyright')

                       -- Nix config
                        vim.lsp.config['nil_ls'] = {
                          capabilities = capabilities,
                          on_attach = function(client, bufnr)
                            attach_keymaps(client, bufnr)
                          end,
                          filetypes = { 'nix' },
                          settings = {
                            ['nil'] = {
                              formatting = {
                                command = {"${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"}
                              },
                              diagnostics = {
                                ignored = { "uri_literal" },
                                excludedFiles = { }
                              },
                              nix = {
                                flake = {
                                  autoArchive = false,
                                  autoEvalInputs = false,
                                  nixpkgsInputName = "nixpkgs"
                                }
                              }
                            }
                          },
                          cmd = {"${pkgs.nil}/bin/nil"}
                        }
                        vim.lsp.enable('nil_ls')

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
                      vim.cmd([[autocmd FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
                      vim.cmd([[augroup end]])

                      -- TS config
                      vim.lsp.config['ts_ls'] = {
                          capabilities = capabilities,
                          on_attach = function(client, bufnr)
                            attach_keymaps(client, bufnr)
                          end,
                          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                          cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" },
                        }
                        vim.lsp.enable('ts_ls')

                      -- HTML config
                      vim.lsp.config['html'] = {
                          capabilities = capabilities,
                          on_attach = function(client, bufnr)
                            attach_keymaps(client, bufnr)
                          end,
                          filetypes = { 'html' },
                          cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
                        }
                        vim.lsp.enable('html')


                      -- C Config
                      vim.lsp.config['clangd'] = {
                          capabilities = capabilities,
                          on_attach = default_on_attach,
                          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
                          cmd = { "${pkgs.llvmPackages_19.clang-tools}/bin/clangd", "--offset-encoding=utf-16" },
                        }
                        vim.lsp.enable('clangd')

                        -- Go Config
                        vim.lsp.config['gopls'] = {
                          capabilities = capabilities,
                          on_attach = default_on_attach,
                          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                          cmd = { "${pkgs.gopls}/bin/gopls", "serve" },
                        }
                        vim.lsp.enable('gopls')

                      -- Lua Config
                 vim.lsp.config['lua_ls'] = {
                        filetypes = { 'lua' },
                        on_init = function(client)
                    if client.workspace_folders then
                      local path = client.workspace_folders[1].name
                      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                        return
                      end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                      runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                      },
                      -- Make the server aware of Neovim runtime files
                      workspace = {
                        checkThirdParty = false,
                        library = {
                          vim.env.VIMRUNTIME
                        }
                      }
                    })
                  end,
                  settings = {
                    Lua = {}
                  }
                }
                vim.lsp.enable('lua_ls')

                      -- Java Config (jdtls)
                      vim.lsp.config['jdtls'] = {
                        capabilities = capabilities,
                        on_attach = default_on_attach,
                        filetypes = { 'java' },
                        cmd = { "${pkgs.jdt-language-server}/bin/jdtls" },
                        settings = {
                          java = {
                            eclipse = {
                              downloadSources = true,
                            },
                            maven = {
                              downloadSources = true,
                            },
                            implementationsCodeLens = {
                              enabled = true,
                            },
                            referencesCodeLens = {
                              enabled = true,
                            },
                            references = {
                              includeDecompiledSources = true,
                            },
                            format = {
                              enabled = true,
                            },
                          },
                          signatureHelp = { enabled = true },
                          completion = {
                            favoriteStaticMembers = {
                              "org.hamcrest.MatcherAssert.assertThat",
                              "org.hamcrest.Matchers.*",
                              "org.hamcrest.CoreMatchers.*",
                              "org.junit.jupiter.api.Assertions.*",
                              "java.util.Objects.requireNonNull",
                              "java.util.Objects.requireNonNullElse",
                              "org.mockito.Mockito.*"
                            },
                          },
                        },
                      }
                      vim.lsp.enable('jdtls')

                      require("telescope").load_extension("ui-select")

    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    -- Display number of folded lines
    local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ('  %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, {suffix, 'MoreMsg'})
      return newVirtText
    end

    require('ufo').setup({
       fold_virt_text_handler = ufo_handler
    })

    -- Using ufo provider needs a large value
    vim.o.foldlevel = 99 
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
  '';
}
