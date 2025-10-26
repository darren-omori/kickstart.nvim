local jdtls = require 'jdtls'
local jdtls_tests = require 'jdtls.tests'

vim.keymap.set('n', '<Leader>tp', function()
  jdtls.pick_test({config = {shortenCommandLine="argfile"}})
end, { buffer = true })
vim.keymap.set('n', '<Leader>tm', function()
  jdtls.test_nearest_method({config = {shortenCommandLine="argfile"}})
end, { buffer = true })
vim.keymap.set('n', '<Leader>tc', function()
  jdtls.test_class({config = {shortenCommandLine="argfile"}})
end, { buffer = true })
vim.keymap.set('n', '<Leader>tg', function()
  jdtls_tests.generate({config = {shortenCommandLine="argfile"}})
end, { buffer = true })
vim.keymap.set('n', '<Leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { buffer = true })

-- Open corresponding source/testing file
vim.keymap.set('n', '<Leader>tt', function()
  local file_name = vim.fn.expand '%:t:r'
  local alt_file_name = string.find(file_name, 'Test') and file_name:sub(1, -5) .. '.java' or file_name .. 'Test.java'
  local alt_files = vim.fs.find(function(name, _)
    return alt_file_name == name
  end, { type = 'file' })
  if #alt_files == 0 then
    vim.print('Failed to find alternate file: ', alt_files)
    return
  end

  vim.cmd.edit(alt_files[1])
end, { silent = true, buffer = true })

-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
  vim.fn.glob('$MASON/packages/java/i".microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', true),
}

-- This is the new part
vim.list_extend(bundles, vim.split(vim.fn.glob('$HOME/.local/share/nvim/vscode-java-test/server/*.jar', true), '\n'))
