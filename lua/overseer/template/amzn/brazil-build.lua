local overseer = require 'overseer'

local function find_package_root(dir)
  local config = vim.fs.find('Config', {
    upward = true,
    path = dir,
  })[1]
  local package_dir = vim.fs.dirname(config)
  return package_dir
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



--stylua: ignore
return {
  generator = function(search, cb)
    local tasks = {}
    local commands = {
      { name = "brazil-build", args = { "release" } },
      { name = "brazil-build test", args = { "test" } },
      { name = "brazil-build ktlintFormat", args = { "ktlintFormat" } },
      { name = "brazil-build clean", args = { "clean" } },
      { name = "brazil-build assemble", args = { "assemble" } },
    }

    local cwd = find_package_root(vim.fs.dirname(vim.fn.expand "%:p"))

    for _, cmd in ipairs(commands) do
      table.insert(tasks, {
        name = cmd.name,
        builder = function()
          return {
            cmd = { "brazil-build" },
            args = cmd.args,
            cwd = cwd,
            components = {
              'default',
              { "on_output_parse", parser = java_parser },
              { "on_result_diagnostics_quickfix", open = true },
            },
          }
        end,
        tags = { overseer.TAG.BUILD },
      })
    end

    cb(tasks)
  end,
  condition = {
    callback = function(opts)
      return find_package_root(opts.dir) ~= nil
    end,
  },
}
