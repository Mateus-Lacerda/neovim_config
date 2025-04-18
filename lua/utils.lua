local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

function PYTHON_PATH()
    local cwd = vim.loop.cwd()
    local where = VENV_BIN_DETECTION('python')
    if where == 'python' then
        return '/usr/bin/python'
    end
    return where
end

function VENV_BIN_DETECTION(tool)
    local cwd = vim.loop.cwd()
    if vim.fn.executable(cwd .. '/.venv/bin/' .. tool) == 1 then
        return cwd .. '/.venv/bin/' .. tool
    end
    return tool
end

function FILE_EXISTS(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end

end

function INSERT_FILENAME()
  builtin.find_files({
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local filename = entry.filename or entry[1]
        vim.api.nvim_feedkeys('a' .. filename, 'n', true)
      end)
      return true
    end
  })
end

