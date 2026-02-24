return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "fei6409/log-highlight.nvim", opts = {} },
	},
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		local parsers = {
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
			"comment",
			"rust",
			"ninja",
			"meson",
			"cmake",
			"regex",
			"yaml",
			"toml",
			"tmux",
			"vim",
			"vimdoc",
			"xml",
			"zsh",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"kitty",
			"latex",
			"query",
			"haskell",
		}

		require("nvim-treesitter").install(parsers, { generate = true, summary = true })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers,
			callback = function(args)
				local bufnr = args.buf
				pcall(vim.treesitter.start, bufnr)
				vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
