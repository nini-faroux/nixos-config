-- LSP Configs --

-- ensure lspconfig loads
local ok = pcall(require, "lspconfig")
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
vim.lsp.enable('luals')
vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  on_attach = on_attach,
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}

-- PureScript lsp
-- This only seems to work with the old require API
-- So have to keep it like this with the annoying warning for now
require('lspconfig').purescriptls.setup {
  cmd = { "purescript-language-server", "--stdio" },
  on_attach = on_attach,
  filetypes = { "purescript" },
  root_dir = require('lspconfig.util').root_pattern("spago.yaml", "flake.nix"),
  settings = {
    purescript = {
      addSpagoSources = true,
      addNpmPath = true,
    },
  },
}

-- Haskell lsp
vim.lsp.enable('hls')
vim.lsp.config['hls'] = {
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
vim.lsp.enable('ts_ls')
vim.lsp.config['ts_ls'] = {
  on_attach = on_attach,
}

-- Nix lsp
vim.lsp.enable('nil_ls')
vim.lsp.config['nil_ls'] = {
  autostart = true,
  on_attach = on_attach,
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
vim.lsp.enable('clangd')
vim.lsp.config['clangd'] = {}

-- Python lsp
vim.lsp.enable('pyright')
vim.lsp.config['pyright'] = {
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

-- Rust lsp
vim.lsp.enable('rust_analyzer')
vim.lsp.config['rust_analyzer'] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
}
