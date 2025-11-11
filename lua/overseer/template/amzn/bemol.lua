local overseer = require 'overseer'

local function find_workspace_root(dir)
  local packageInfo = vim.fs.find('packageInfo', {
    upward = true,
    path = dir,
  })[1]
  local workspace_dir = vim.fs.dirname(packageInfo)
  return workspace_dir
end

-- local function dump(o)
--    if type(o) == 'table' then
--       local s = '{ '
--       for k,v in pairs(o) do
--          if type(k) ~= 'number' then k = '"'..k..'"' end
--          s = s .. '['..k..'] = ' .. dump(v) .. ','
--       end
--       return s .. '} '
--    else
--       return tostring(o)
--    end
-- end

local java_parser = {
  -- Put the parser results into the 'diagnostics' field on the task result
  diagnostics = {
    -- Extract fields using lua patterns
    -- To integrate with other components, items in the "diagnostics" result should match
    -- vim's quickfix item format (:help setqflist)
    -- { "extract", [[ (\(.+):(%d+) ]], "filename", "lnum" },
    -- { "extract", [[ (.*) ]], "filename" },
    { 'extract', [[.*(at [^(]*%(([^:]+):(%d+).*)]], 'text', 'filename', 'lnum' },
  },
}
-- local java_parser = {
--   diagnostics = {
--     {"extract",
--       {regex = true},
--       "^(\\S+) > (.*) FAILED$",
--       "filename",
--       "text"
--     }
--   }
-- }



return {
  name = "bemol",
  builder = function()
    local cwd = find_workspace_root(vim.fs.dirname(vim.fn.expand "%:p"))
    return {
      cmd = { '/apollo/env/envImprovement/bin/tmux'},
      args = { "new-session", "-A", "-s", vim.fn.fnamemodify(cwd, ":t").."-bemol", "bemol --verbose --watch"},
      cwd = cwd,
      components = {
        'default',
	{ "on_output_parse", parser = java_parser },
	{ "on_result_diagnostics_quickfix", open = true },
		},
	}
  end,
  condition = {
    callback = function(opts)
      return find_workspace_root(opts.dir) ~= nil
    end,
  }
}
