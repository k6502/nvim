return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters.bacon = {
			cmd = "bacon",
			args = { "--headless", "--job", "check", "--no-summary" },
			stdin = false,
			append_fname = false,
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_pattern(
				"([^:]+):(%d+):(%d+):%s+(%w+):%s+(.*)",
				{ "file", "lnum", "col", "severity", "message" },
				{
					["error"] = vim.diagnostic.severity.ERROR,
					["warning"] = vim.diagnostic.severity.WARN,
					["note"] = vim.diagnostic.severity.HINT,
					["help"] = vim.diagnostic.severity.INFO,
				},
				{ ["source"] = "bacon" }
			),
		}

		lint.linters_by_ft = {
			lua = { "selene" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			rust = { "bacon" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
