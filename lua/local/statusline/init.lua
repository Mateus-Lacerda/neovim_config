-- Mode indicators with Nerd Font icons
local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = "  NORMAL",
        i = "  INSERT",
        v = "  VISUAL",
        V = "  V-LINE",
        ["\22"] = "  V-BLOCK",
        c = "  COMMAND",
        s = "  SELECT",
        S = "  S-LINE",
        ["\19"] = "  S-BLOCK",
        R = "  REPLACE",
        r = "  REPLACE",
        ["!"] = "  SHELL",
        t = "  TERMINAL",
    }
    return " " .. (modes[mode] or mode)
end

_G.mode_icon = mode_icon

local function diagnostics_counter()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    local parts = {}

    if errors > 0 then table.insert(parts, " " .. errors) end
    if warnings > 0 then table.insert(parts, " " .. warnings) end
    if hints > 0 then table.insert(parts, " " .. hints) end
    if info > 0 then table.insert(parts, " " .. info) end

    if #parts > 0 then
        return "  " .. table.concat(parts, " ")
    end
    return ""
end

_G.diagnostics_counter = diagnostics_counter


vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "  ",
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " \u{e0b1} %f %h%m%r",            -- Nome do arquivo e flags
                "%{v:lua.diagnostics_counter()}", -- [[ AQUI: O novo contador ]]
                " \u{e0b1}",                      -- Divisor fechando a seção
                "%=",                             -- Right-align everything after this
                " %l:%c  %P ",                    -- nf-fa-clock_o for line/col
            })
        end,
    })
    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r %=  %l:%c   %P "
        end,
    })
end

setup_dynamic_statusline()
