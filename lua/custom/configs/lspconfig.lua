local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require('lspconfig')

lspconfig.solargraph.setup({
  on_attach = function(client, bufnr)
    -- Automatically format on save if the LSP supports it
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
local null_ls = require('null-ls')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- null-ls setup for Rubocop
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.rubocop.with({
      command = "rubocop",
      args = { "--format", "json", "--stdin", "$FILENAME" },
    }),
  },
})

local servers = { "ts_ls", "tailwindcss", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
