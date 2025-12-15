--- TELESCOPE ---
local builtin = require("telescope.builtin")

vim.api.nvim_set_keymap("n", "<leader>fp", "<cmd>lua INSERT_FILENAME()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

--- HARPOON ---
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

-- Quickfix
vim.keymap.set("n", "<M-l>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<M-o>", "<cmd>copen<CR>")
vim.keymap.set("n", "<M-c>", "<cmd>cclose<CR>")

-- Disable Arrow Keys in Normal Mode --
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

-- -- COPILOT --
-- -- Enable Copilot
-- vim.keymap.set("n", "<leader>cpe", function ()
--     vim.cmd("Copilot enable")
--     print("Copilot enabled")
-- end)
--
-- -- Disable Copilot
-- vim.keymap.set("n", "<leader>cpd", function ()
--     vim.cmd("Copilot disable")
--     print("Copilot disabled")
-- end)
-- -- Remap Copilot accept to <S-Tab>
-- vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
--      expr = true,
--      replace_keycodes = false
-- })
-- vim.g.copilot_no_tab_map = true

-- Augment
vim.keymap.set("n", "<leader>aud", function() vim.g.augment_disable_completions = true end)
vim.keymap.set("n", "<leader>aue", function() vim.g.augment_disable_completions = false end)

local sysrun = require("util.run_selecion")

vim.keymap.set("x", "<leader>rb", sysrun.run_bash,   { desc = "Run selected Bash" })
vim.keymap.set("x", "<leader>rp", sysrun.run_python, { desc = "Run selected Python" })


-- 
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-J>", ":t.<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-K>", ":t-1<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("i", "<A-J>", "<C-o>:t.<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-K>", "<C-o>:t-1<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-J>", ":t-1<CR>gv", { noremap = true, silent = true })
vim.keymap.set("v", "<A-K>", ":t'><CR>gv", { noremap = true, silent = true })


-- Oil
vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" })
