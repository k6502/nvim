return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {},
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
