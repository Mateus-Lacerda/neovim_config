local persist_dir = vim.fn.expand("~/.config/mlm_scratcher")

local exts = {
  { label = "Markdown", ext = "md" },
  { label = "Python", ext = "py" },
  { label = "Bash", ext = "sh" },
  { label = "JavaScript", ext = "js" },
  { label = "Lua", ext = "lua" },
  { label = "JSON", ext = "json" },
}

-- <leader>ss: seletor de extensão para abrir scratch
vim.keymap.set("n", "<leader>ss", function()
  vim.ui.select(exts, {
    prompt = "Escolha o tipo de scratch:",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    local scratchfile = "/tmp/scratch/temp." .. choice.ext
    local current = vim.api.nvim_buf_get_name(0)
    if string.match(current, "^/tmp/scratch/") or string.match(current, "^" .. vim.fn.expand("~/.config/mlm_scratcher/")) then
      vim.cmd("edit " .. scratchfile)
    else
      -- Abrir em floating window sem trocar o buffer atual
      local width = math.floor(vim.o.columns * 0.7)
      local height = math.floor(vim.o.lines * 0.7)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      -- cria novo buffer e carrega o conteúdo do arquivo scratch nele
      local buf = vim.fn.bufnr(scratchfile)
      if buf == -1 then
        buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_set_name(buf, scratchfile)
        -- Define filetype baseado na extensão
        local ext_to_ft = {
          md = "markdown",
          py = "python",
          sh = "sh",
          js = "javascript",
          lua = "lua",
          json = "json",
        }
        vim.api.nvim_buf_set_option(buf, 'filetype', ext_to_ft[choice.ext] or choice.ext)
      end
      -- carrega o conteúdo do arquivo, se existir
      local f = io.open(scratchfile, "r")
      if f then
        local content = f:read("*a")
        f:close()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
      end
      vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
      })
      vim.api.nvim_set_current_buf(buf)
    end
  end)
end, { desc = "Abrir scratch com seletor de extensão" })

-- <leader>sp: persistir scratch atual (apenas se estiver em /tmp/scratch/ ou ~/.config/mlm_scratcher/)
vim.keymap.set("n", "<leader>sp", function()
  local current = vim.api.nvim_buf_get_name(0)
  if not (string.match(current, "^/tmp/scratch/") or string.match(current, "^" .. vim.fn.expand("~/.config/mlm_scratcher/"))) then
    print("Só é possível persistir arquivos do scratch!")
    return
  end
  local ext = vim.fn.expand("%:e")
  local date = os.date("%Y-%m-%d")
  local time = os.date("%H-%M-%S")
  local target_dir = persist_dir .. "/" .. date
  vim.fn.mkdir(target_dir, "p")
  local target_file = string.format("%s/%s.%s", target_dir, time, ext)
  vim.cmd("write! " .. target_file)
  print("Persistido em: " .. target_file)
end, { desc = "Persistir scratch atual" })

-- <leader>sl: listar e abrir notas persistidas (abre flutuante se não estiver em /tmp/scratch/ ou ~/.config/mlm_scratcher/)
vim.keymap.set("n", "<leader>sl", function()
  local notes = {}
  local handle = io.popen("find " .. persist_dir .. " -type f 2>/dev/null")
  if handle then
    for file in handle:lines() do
      table.insert(notes, file)
    end
    handle:close()
  end
  if #notes == 0 then
    print("Nenhuma nota encontrada.")
    return
  end
  vim.ui.select(notes, {prompt = "Escolha uma nota para abrir:"}, function(choice)
    if not choice then return end
    local current = vim.api.nvim_buf_get_name(0)
    if string.match(current, "^/tmp/scratch/") or string.match(current, "^" .. vim.fn.expand("~/.config/mlm_scratcher/")) then
      vim.cmd("edit " .. choice)
    else
      -- Abrir em floating window
      local width = math.floor(vim.o.columns * 0.7)
      local height = math.floor(vim.o.lines * 0.7)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      vim.cmd("edit " .. choice)
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
      })
    end
  end)
end, { desc = "Listar e abrir notas persistidas" })

