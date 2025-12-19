-- Using fzf-lua
local function find_workspace_root(dir)
  local packageInfo = vim.fs.find('packageInfo', {
    upward = true,
    path = dir,
  })[1]
  local workspace_dir = vim.fs.dirname(packageInfo)
  return workspace_dir
end

return {
  {
    "ibhagwan/fzf-lua",
    enabled = true,
    lazy = "VeryLazy",
    keys = {
      {
        "<leader>sf",
        function()
          require("fzf-lua").global()
        end,
        silent = true,
        desc = "[S]earch [W]orkspace",
      },
      {
        "<leader>sw",
        function()
          require("fzf-lua").global({cwd=find_workspace_root(vim.uv.cwd())})
          -- vim.api.nvim_feedkeys("!tst ", "n", false)
        end,
        silent = true,
        desc = "[S]earch [W]orkspace",
      },
      {
        "<leader>sn",
        function()
          require("fzf-lua").files({cwd=vim.fn.stdpath 'config'})
          -- vim.api.nvim_feedkeys("!tst ", "n", false)
        end,
        silent = true,
        desc = "[S]earch [W]orkspace",
      },
      {
        "<leader>st",
        "<cmd>FzfLua files<cr>",
        silent = true,
        desc = "[S]earch [F]iles",
      },
      {
        "<leader>sg",
        function()
          require("fzf-lua").live_grep_native()
        end,
        silent = true,
        desc = "[S]earch by [G]rep",
      },
      {
        "<leader>sl",
        function()
          require("fzf-lua").lsp_live_workspace_symbols()
        end,
        silent = true,
        desc = "[Search] [L]SP symbols",
      },
      {
        "<leader><leader>",
        function()
          require("fzf-lua").buffers()
        end,
        silent = true,
        desc = "[ ] Search Open Buffers"
      },
      {
        "**",
        function()
          require("fzf-lua").grep_visual()
          -- vim.api.nvim_feedkeys("!test ", "n", false)
        end,
        mode = "v",
        silent = true,
        desc = "Grep visual selection",
      },
      {
        "**",
        function()
          require("fzf-lua").grep_cword()
          -- vim.api.nvim_feedkeys("!test ", "n", false)
        end,
        mode = "n",
        silent = true,
        desc = "Grep word under cursor",
      },
      -- {
      --   "<leader>qf",
      --   function()
      --     require("fzf-lua").quickfix()
      --   end,
      --   mode = "n",
      --   silent = true,
      --   desc = "Quickfix (fzf)",
      -- },
      -- {
      --   "<c-m>",
      --   function()
      --     require("fzf-lua").marks()
      --   end,()
      --   silent = true,
      --   desc = "List marks (fzf)",
      -- },
      {
        "<leader>sd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        silent = true,
        desc = "[S]earch [D]iagnostics"
      },
      {
        "<leader>hH",
        "<cmd>FzfLua highlights<cr>",
        silent = true,
        desc = "Neovim highlight groups (fzf)",
      },
      {
        "<leader>hh",
        "<cmd>FzfLua help_tags<cr>",
        silent = true,
        desc = "Neovim help tags (fzf)",
      },
      {
        "<leader>hk",
        "<cmd>FzfLua keymaps<cr>",
        silent = true,
        desc = "Neovim keymaps (fzf)",
      },
      {
        "<leader>hc",
        "<cmd>FzfLua commands<cr>",
        silent = true,
        desc = "Neovim commands (fzf)",
      },
      {
        "<leader>gl",
        "<cmd>FzfLua git_bcommits<cr>",
        silent = true,
        desc = "Git log current buffer (fzf)",
      },
      {
        "<leader>fj",
        "<cmd>FzfLua jumps<cr>",
        silent = true,
        desc = "Jump list (fzf)",
      },
      {
        "grx",
        "<cmd>FzfLua lsp_references<cr>",
        silent = true,
        desc = "LSP References (fzf)",
      },
      {
        "<c-\\>",
        "<cmd>FzfLua resume<cr>",
        silent = true,
        desc = "Resume FzfLua",
      },
    },
    cmd = {
      "FzfLua",
    },
    opts = {
      "hide",
      "border-fused",
      -- preview={default="down"}
      -- fzf_opts = {
      --   ['--preview-window'] = 'nohidden,down,50%',
      -- },
      fzf_opts = {
        ["--history"] = vim.fn.stdpath "data" .. "fzf-lua-history",
        ["--padding"] = "1,2",
        ['--cycle'] = true,
      },
      winopts = {
        backdrop = 30,
        preview = {
          default = "builtin",
          vertical = "down:60%",
          horizontal = "right:60%",
          layout = "vertical", -- Note: `vertical` is good for long lines
          scrollbar = "border",
        },
        treesitter = {
          enabled = true,
          -- fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
        },
      },
      fzf_colors = {
        ["bg+"] = { "bg", "FzfLuaFzfCursorLine" },
        ["separator"] = { "fg", "FzfLuaFzfSeparator" },
        ["gutter"] = "-1",
      },
      previewers = {
        builtin = {
          extensions = {
            -- neovim terminal only supports `viu` block output
            ["png"] = { "viu", "-b" },
            ["jpg"] = { "viu", "-b" },
            ["jpeg"] = { "viu", "-b" },
          },
        },
      },
      keymap = {
        fzf = {
          ["tab"] = "down",
          ["shift-tab"] = "up",
        }
      }
    },
    config = function(_, opts)
      local fzf = require "fzf-lua"
      fzf.setup(opts)
      -- Use fzf as a ui-select
      fzf.register_ui_select()
    end,
  },
  -- {
  --   "junegunn/fzf",
  --   lazy = "VeryLazy",
  --   build = ":call fzf#install()",
  -- },
}
