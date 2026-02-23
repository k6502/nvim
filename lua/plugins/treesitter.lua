return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "fei6409/log-highlight.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").haxe = {
					install_info = {
						url = "https://github.com/vantreeseba/tree-sitter-haxe",
						files = { "src/parser.c", "src/scanner.c" },
						branch = "main",
					},
					filetype = "haxe",
				}
			end,
		})

		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
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
			"haxe", -- Included in the list
		}

		require("nvim-treesitter").install(parsers)

		vim.o.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local bufnr = args.buf
				local ft = vim.bo[bufnr].filetype
				local ignore_ft = { "noice", "notify", "lspinfo", "checkhealth" }

				if vim.tbl_contains(ignore_ft, ft) then
					return
				end

				local lang = vim.treesitter.language.get_lang(ft) or ft
				local has_parser, _ = pcall(vim.treesitter.get_parser, bufnr, lang)

				if has_parser then
					vim.treesitter.start(bufnr, lang)
					vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
