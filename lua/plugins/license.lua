return {
	"attilarepka/header.nvim",
	dependencies = {
		{
			"GR3YH4TT3R93/licenses.nvim",
			lazy = false,
			opts = {
				copyright_holder = "kptr",
				email = "dev@kthread.dev",
				license = "GPLv3",
			},
			keys = {},
		},
	},
	lazy = false,
	config = function()
		require("header").setup({
			allow_autocmds = true,
			file_name = true,
			author = "kptr (k6502) <dev@kthread.dev>",
			date_created = true,
			date_created_fmt = "%d/%m/%Y %H:%M:%S",
			date_modified = true,
			date_modified_fmt = "%d/%m/%Y %H:%M:%S",
			line_separator = "------",
			use_block_header = true,
			license_from_file = true,
			author_from_git = false,
		})
	end,
}
