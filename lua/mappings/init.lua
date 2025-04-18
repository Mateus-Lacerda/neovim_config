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
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<M-o>", "<cmd>copen<CR>")
vim.keymap.set("n", "<M-c>", "<cmd>cclose<CR>")

-- Disable Arrow Keys in Normal Mode --
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

-- COPILOT --
-- Enable Copilot
vim.keymap.set("n", "<leader>cpe", function ()
    vim.g.copilot_enabled = true
    print("Copilot enabled")
end)
-- Disable Copilot
vim.keymap.set("n", "<leader>cpd", function ()
    vim.g.copilot_enabled = false
    print("Copilot disabled")
end)
-- Open Copilot Chat
vim.keymap.set("n", "<leader>cpc", function ()
    vim.cmd("CopilotChatOpen")
end)
-- View avaialable models
vim.keymap.set("n", "<leader>cpm", function ()
    vim.cmd("CopilotChatModels")
end)
-- View avaialable agents
vim.keymap.set("n", "<leader>cpa", function ()
    vim.cmd("CopilotChatAgents")
end)
