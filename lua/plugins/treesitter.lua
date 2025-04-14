 return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "python", "markdown", "rust" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
            ignore_install = { },
            auto_install = true,
            modules = { },
		})
	end
}

