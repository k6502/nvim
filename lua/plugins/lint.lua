return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	lazy = false,
	config = function()
		require("lint").linters_by_ft = {
			lua = { "selene" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			rust = { "bacon" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
