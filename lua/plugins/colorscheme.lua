return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    -- config = function()
    --   require('tokyonight').setup {
    --     transparent = false,
    --     styles = {
    --       sidebars = 'transparent',
    --       floats = 'transparent',
    --     },
    --   }
    -- end,
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'catppuccin-macchiato'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- {
  --   'gbprod/nord.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('nord').setup {}
  --     vim.cmd.colorscheme 'nord'
  --   end,
  -- },
  -- { 'rebelot/kanagawa.nvim' },
  -- { 'neanias/everforest-nvim' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'Shatur/neovim-ayu' },
}
