return {
	"folke/which-key.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		preset = "modern",
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false, keys = "<c-w>", loop = true })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
