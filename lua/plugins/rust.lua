return {
	"mrcjkb/rustaceanvim",
	dependencies = {
		{
			"saecki/crates.nvim",
			config = function()
				require("crates").setup()
			end,
		},
	},
	version = "^8",
	lazy = false,
}
