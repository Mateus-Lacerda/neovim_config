---@diagnostic disable: param-type-mismatch  -- garante paz em versões mistas do LSP

local M = {}

----------------------------------------------------------------------
-- devolve as linhas visualmente selecionadas ou `nil`
----------------------------------------------------------------------
local function get_selection()
  local mode = vim.fn.mode()
  if not mode:match("[vV]") then
    vim.notify("Selecione o código primeiro (permaneça em Visual Mode)", vim.log.levels.WARN)
    return nil
  end
  local p1 = vim.fn.getpos("'<")[2]
  local p2 = vim.fn.getpos("'>")[2]
  return vim.api.nvim_buf_get_lines(0, p1 - 1, p2, false)
end

----------------------------------------------------------------------
-- executa comando via vim.system() e mostra stdout / stderr num toast
----------------------------------------------------------------------
---@param cmd_tbl  string[]          -- ex.: { "bash", "-s" }
---@param src_lines string[]         -- código-fonte a ser passado via stdin
---@param title     string           -- título da notificação
local function system_run(cmd_tbl, src_lines, title)
  vim.system(
    cmd_tbl,
    { stdin = table.concat(src_lines, "\n") },      -- opts: table; evita warning
    function(res)
      local stdout = table.concat(res.stdout or {}, "")
      local stderr = table.concat(res.stderr or {}, "")
      local out = (stdout .. (stderr ~= "" and ("\n" .. stderr) or "")):gsub("%s+$", "")
      if out == "" then out = "[" .. title .. "] sem saída" end
      vim.notify(out, vim.log.levels.INFO, { title = title, timeout = 8000 })
    end
  )
end

----------------------------------------------------------------------
-- wrappers para Bash e Python
----------------------------------------------------------------------
function M.run_bash()
  local lines = get_selection()
  if not lines then return end
  system_run({ "bash", "-s" }, lines, "Bash output")   -- -s lê script do stdin
end

function M.run_python()
  local lines = get_selection()
  if not lines then return end
  system_run({ "python3", "-" }, lines, "Python output") -- "-" = stdin
end

return M
----------------------------------------------------------------------

