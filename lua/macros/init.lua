local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

vim.api.nvim_create_augroup("Python", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = "Python",
    pattern = { "python" },
    callback = function()
        vim.fn.setreg("l", "yologger.info(\"" .. esc .. "pA: %s\", " .. esc .. "pA)" .. esc)
    end,
})
