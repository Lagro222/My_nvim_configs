-- Load NvChad's default LSP config for on_init (semantic tokens disable, etc.)
local default_config = require "nvchad.configs.lspconfig"
local on_init = default_config.on_init

-- Use blink.cmp's LSP capabilities (proper snippet/completion support)
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Global base config for all servers
vim.lsp.config("*", {
  capabilities = capabilities,
  on_init = on_init,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Disable formatting for ts_ls (conform/prettierd handles it)
    if client and client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Auto-fix all ESLint issues on save
    if client and client.name == "eslint" then
      local group = vim.api.nvim_create_augroup("EslintFixAll_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end
  end,
})

-- HTML LSP
vim.lsp.config("html", {})

-- CSS LSP
vim.lsp.config("cssls", {})

-- TailwindCSS LSP
vim.lsp.config("tailwindcss", {
  root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts" },
})

-- Bash LSP
vim.lsp.config("bashls", {
  filetypes = { "sh", "bash" },
})

-- Markdown LSP
vim.lsp.config("marksman", {
  filetypes = { "markdown", "markdown.mdx" },
})

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
        importModuleSpecifierPreference = "shortest",
      },
    },
    javascript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
        importModuleSpecifierPreference = "shortest",
      },
    },
  },
})

-- Angular LSP
local ng_cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  vim.fn.stdpath "data" .. "/mason/packages/angular-language-server/node_modules",
  "--ngProbeLocations",
  vim.fn.stdpath "data" .. "/mason/packages/angular-language-server/node_modules/@angular/language-server/node_modules",
}

vim.lsp.config("angularls", {
  cmd = ng_cmd,
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
  root_markers = { "angular.json", "nx.json" },
  on_new_config = function(new_config)
    new_config.cmd = ng_cmd
  end,
})

-- JSON LSP
vim.lsp.config("jsonls", {})

-- ESLint LSP
vim.lsp.config("eslint", {})

-- Emmet LSP
vim.lsp.config("emmet_ls", {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascriptreact",
    "typescriptreact",
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
      },
    },
  },
})

-- GraphQL LSP
vim.lsp.config("graphql", {
  filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
  root_markers = {
    ".graphqlrc",
    ".graphqlrc.yml",
    ".graphqlrc.yaml",
    ".graphqlrc.json",
    "graphql.config.js",
    "graphql.config.ts",
  },
})

-- YAML LSP
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose*.yml",
          "compose*.yml",
        },
        ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yml",
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

-- C/C++ LSP
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

-- Prisma LSP
vim.lsp.config("prismals", {})

-- Docker LSP
vim.lsp.config("dockerls", {})

-- Docker Compose LSP
vim.lsp.config("docker_compose_language_service", {})

-- Lua LSP
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
      runtime = {
        version = "LuaJIT",
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- -- Java
-- vim.lsp.config("jdtls", {
--   settings = {
--     java = {
--       format = { enabled = true },
--       inlayHints = {
--         parameterNames = { enabled = "all" },
--       },
--       completion = {
--         importOrder = { "java", "jakarta", "org", "com" },
--       },
--     },
--   },
-- })

-- Enable all servers
vim.lsp.enable {
  "html",
  "cssls",
  "tailwindcss",
  "bashls",
  "marksman",
  "ts_ls",
  "angularls",
  "jsonls",
  "eslint",
  "emmet_ls",
  "graphql",
  "yamlls",
  "clangd",
  "prismals",
  "dockerls",
  "docker_compose_language_service",
  -- "jdtls",
}

vim.diagnostic.config {
  update_in_insert = false,
}

-- -- Python LSP (uncomment when needed)
-- vim.lsp.config("pyright", {})
-- vim.lsp.enable { "pyright" }
