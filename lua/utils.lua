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
