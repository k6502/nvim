return {
	"stevearc/conform.nvim",
	lazy = false,
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
