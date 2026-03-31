return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Preserve existing clangd configuration
    opts.servers = opts.servers or {}
    opts.servers.clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        -- Disable automatic header instertion
        -- "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
    }

    -- Don't let Mason try to handle this custom server
    opts.servers.devicetree_ls = nil

    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable semantic tokens
    capabilities.textDocument = capabilities.textDocument or {}
    capabilities.textDocument.semanticTokens = {
      dynamicRegistration = false,
      requests = {
        range = false,
        full = true,
      },
      tokenTypes = {
        "namespace", "class", "enum", "interface", "struct", "typeParameter", "type",
        "parameter", "variable", "property", "enumMember", "decorator", "event", "function",
        "method", "macro", "label", "comment", "string", "keyword", "number", "regexp", "operator",
      },
      tokenModifiers = {
        "declaration", "definition", "readonly", "static", "deprecated", "abstract",
        "async", "modification", "documentation", "defaultLibrary",
      },
      formats = { "relative" },
    }

    -- Enable formatting
    capabilities.textDocument.formatting = {
      dynamicRegistration = false,
    }

    -- Enable folding range support
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    if not configs.devicetree_ls then
      configs.devicetree_ls = {
        default_config = {
          cmd = { "devicetree-language-server", "--stdio" },
          filetypes = { "dts", "dtsi" },
          root_dir = lspconfig.util.root_pattern("zephyr", ".git", "."),
          settings = {
            devicetree = {
              defaultIncludePaths = {
                "./zephyr/dts",
                "./zephyr/dts/arm",
                "./zephyr/dts/arm64/",
                "./zephyr/dts/riscv",
                "./zephyr/dts/common",
                "./zephyr/dts/vendor",
                "./zephyr/include",
              },
              cwd = "${workspaceFolder}",
              defaultBindingType = "Zephyr",
              defaultZephyrBindings = {
                "./zephyr/dts/bindings",
              },
              autoChangeContext = true,
              allowAdhocContexts = true,
              contexts = {},
            },
          },
          capabilities = capabilities,
        },
      }
    end

    vim.notify("Custom devicetree_ls LSP loaded with semantic tokens & folding")

    -- Setup the LSP
    lspconfig.devicetree_ls.setup({
      capabilities = capabilities,
    })
  end,
}
