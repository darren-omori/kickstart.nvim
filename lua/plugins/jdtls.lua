local function on_attach()
  local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
  local ws_folders_lsp = {}
  if bemol_dir then
    local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
    if file then
      for line in file:lines() do
        table.insert(ws_folders_lsp, line)
      end
      file:close()
    end
  end
  for _, line in ipairs(ws_folders_lsp) do
    vim.lsp.buf.add_workspace_folder(line)
  end
end

return {
  {
    'mfussenegger/nvim-jdtls',
    -- enabled = false,
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'mason-org/mason.nvim',
      'mfussenegger/nvim-dap',
      'j-hui/fidget.nvim',
    },
    ft = { 'java' },
    cmd = {
      'JdtShowLogs',
      'JdtWipeDataAndRestart',
    },
    config = function()
      local bundles = {
        vim.fn.expand('$MASON/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true),
      }
      
      local root_dir = vim.fs.root(vim.api.nvim_buf_get_name(0), { ".git" })

      -- How to find the project name for a given root dir.
      local project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir)
      end

      vim.list_extend(bundles, vim.split(vim.fn.glob('$MASON/packages/java-test/extension/server/*.jar', true), '\n'))
      vim.lsp.config('jdtls', {
        filetypes = { 'java' },
        on_attach = on_attach,
        cmd = {
          'jdtls',
          '--jvm-arg=' .. '-javaagent:' .. vim.fn.expand '$MASON/packages/jdtls/lombok.jar' .. '',
          '--configuration',
          './config_linux',
          '--data ',
          os.getenv("HOME") .. "/.cache/jdtls/" .. project_name(root_dir) .. "/workspace"
        },
        init_options = {
          bundles = bundles,
        },
        capabilities = vim.tbl_deep_extend('force', {
          workspace = {
            configuration = true,
          },
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
              },
            },
          },
        }, require('blink.cmp').get_lsp_capabilities()),
        settings = {
          java = {
            references = {
              includeDecompiledSources = true,
            },
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            signatureHelp = { enabled = true },
          },
        },
      })
      vim.lsp.enable('jdtls', true)

      -- dap
    end,
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "rcasia/neotest-java",
  --   },
  --   opts = function()
  --     return {
  --       log_level = vim.log.levels.DEBUG,
  --       adapters = {
  --         require "neotest-java" {
  --           -- config here
  --         },
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "rcasia/neotest-java",
  --   ft = "java",
  --   -- dev = true,
  --   dependencies = {
  --     "mfussenegger/nvim-jdtls",
  --     "mfussenegger/nvim-dap",
  --   },
  -- },
}
