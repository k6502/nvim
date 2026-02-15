return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = { "m-demare/hlargs.nvim" },
	config = function()
		require("nvim-treesitter").install({
			"lua",
			"c",
			"cpp",
			"make",
			"markdown",
			"markdown_inline",
			"asm",
			"nasm",
			"llvm",
			"python",
			"bash",
			"linkerscript",
			"rust",
			"ninja",
			"meson",
			"cmake",
			"regex",
			"yaml",
			"toml",
			"tmux",
			"vim",
		})
		require("hlargs").setup({})
	end,
}
