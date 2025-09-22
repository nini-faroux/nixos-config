-- LSP Configs --

-- ensure lspconfig loads
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local on_attach = function(_, bufnr)

  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  -- LSP shortcuts
  bufmap('<leader>r', vim.lsp.buf.rename)
  bufmap('<leader>a', vim.lsp.buf.code_action)

  bufmap('gd', vim.lsp.buf.definition)
  bufmap('gD', vim.lsp.buf.declaration)
  bufmap('gI', vim.lsp.buf.implementation)
  bufmap('<leader>D', vim.lsp.buf.type_definition)

  bufmap('gl', vim.diagnostic.open_float, 'Show diagnostics in float')

  bufmap('gr', require('telescope.builtin').lsp_references)
  bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('K', vim.lsp.buf.hover)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.semanticHighlighting = true

-- Colour scheme
vim.cmd.colorscheme("tokyonight")
capabilities.textDocument.semanticTokens = {
  dynamicRegistration = false,
  requests = {
    range = true,
    full = true,
  },
  tokenTypes = {
    "namespace", "type", "class", "enum", "interface", "struct", "typeParameter",
    "parameter", "variable", "property", "enumMember", "event", "function",
    "method", "macro", "keyword", "modifier", "comment", "string", "number",
    "regexp", "operator"
  },
  tokenModifiers = {
    "declaration", "definition", "readonly", "static", "deprecated", "abstract",
    "async", "modification", "documentation", "defaultLibrary"
  },
  formats = { "relative" },
  overlappingTokenSupport = false,
  multilineTokenSupport = false,
  style = "night",
  styles = {
    keywords = { italic = true },
    functions = { italic = true },
    variables = {},
    sidebars = "light",
    floats = "light",
  },

}

-- Set a custom color for Haskell function declarations
vim.api.nvim_set_hl(0, "@function.haskell", { fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "@function.call.haskell", { fg = "#f4415f" })  -- for function *calls*

-- Optional: highlight type declarations
vim.api.nvim_set_hl(0, "@type.haskell", { fg = "#ffffff", italic = true })

-- Override the comment color (and optionally styling)
vim.api.nvim_set_hl(0, "Comment", { fg = "#b4f9f8", italic = true })

-- Lua lsp
require('neodev').setup()
require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
	root_dir = function()
        return vim.loop.cwd()
    end,
	cmd = { "lua-lsp" },
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    }
}

-- PureScript lsp
lspconfig.purescriptls.setup {
  cmd = { "purescript-language-server", "--stdio" },
  filetypes = { "purescript" },
  -- Detect project root via spago.yaml
  root_dir = lspconfig.util.root_pattern("spago.yaml", "flake.nix"),
  settings = {
    purescript = {
      addSpagoSources = true,
      addNpmPath = true,
    },
  },
}

-- Haskell lsp
require'lspconfig'.hls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    haskell = {
      hlintOn = true,
      formattingProvider = "fourmolu",
      plugin = {
        hlint = {
          globalOn = true
        }
      }
    }
  }
}

-- TypeScript lsp
require('lspconfig')['ts_ls'].setup{
  on_attach = on_attach,
}

-- Nix lsp
require('lspconfig').nil_ls.setup {
  autostart = true,
  capabilities = caps,
  cmd = { "/nix/store/77rg4vvvrc4xx5h2ia1qmy9inajnsq8i-home-manager-path/bin/nil" },
  settings = {
    ['nil'] = {
      testSetting = 42,
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
}

-- C lsp
require('lspconfig').clangd.setup{}

-- Python lsp
require('lspconfig').pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}

require('lspconfig').ruff.setup{}
