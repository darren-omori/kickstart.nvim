-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'ThePrimeagen/vim-be-good',
  'mfussenegger/nvim-jdtls',
  {
    {
      'stevearc/oil.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('oil').setup {
          columns = { 'icon' },
          keymaps = {
            ['<C-h>'] = false,
            ['<M-h>'] = 'actions.select_split',
          },
          view_options = {
            show_hidden = true,
          },
        }

        -- Open parent directory in current window
        vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

        -- Open parent directory in floating window
        vim.keymap.set('n', '<space>-', require('oil').toggle_float)
      end,
    },
  },
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
  },
}
