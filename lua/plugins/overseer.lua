-- Job worker
return {
  "stevearc/overseer.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  cmd = {
    "Make",
    "OverseerShell",
    "OverseerOpen",
    "OverseerRun",
    "OverseerToggle",
  },
  keys = {
    {
      "<leader>rr",
      "<cmd>OverseerRun<CR>",
      silent = true,
      desc = "Run job - OverseerRun",
    },
    {
      "<leader>rt",
      "<cmd>OverseerToggle<CR>",
      silent = true,
      desc = "Toggle jobs - OverseerToggle",
    },
  },
  opts = {
    templates = {
      "builtin",
    },
    task_list = {
      bindings = {
        ["<C-k>"] = false,
        ["<C-l>"] = false,
        ["<C-h>"] = false,
      },
    },
  },
  config = function(_, opts)
    local overseer = require "overseer"
    overseer.setup(opts)
    vim.api.nvim_create_user_command("Make", function(params)
      -- Insert args at the '$*' in the makeprg
      local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
      if num_subs == 0 then
        cmd = cmd .. " " .. params.args
      end
      local task = require("overseer").new_task {
        cmd = vim.fn.expandcmd(cmd),
        components = {
          { "on_output_quickfix", open = not params.bang, open_height = 8 },
          "unique",
          "default",
        },
      }
      task:start()
    end, {
      desc = "Run makeprg as an Overseer task",
      nargs = "*",
      bang = true,
    })

    vim.api.nvim_create_user_command("OverseerRestartLast", function()
      local overseer = require "overseer"
      local tasks = overseer.list_tasks { recent_first = true }
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], "restart")
      end
    end, {
      desc = "Restart last Overseer task",
    })
  end,
}
