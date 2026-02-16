return {
	"wsdjeg/ctags.nvim",
	dependencies = { "wsdjeg/job.nvim", "wsdjeg/rooter.nvim", "wsdjeg/logger.nvim" },
	config = function()
		require("ctags").setup({
			cache_dir = vim.fn.stdpath("data") .. "/ctags.nvim/",
		})
		local function update_ctags_option()
			local project_root = vim.fn.getcwd()
			local dir = require("ctags.util").unify_path(require("ctags.config").cache_dir)
				.. require("ctags.util").path_to_fname(project_root)
			local tags = vim.tbl_filter(function(t)
				return not vim.startswith(t, require("ctags.util").unify_path(require("ctags.config").cache_dir))
			end, vim.split(vim.o.tags, ","))
			table.insert(tags, dir .. "/tags")
			vim.o.tags = table.concat(tags, ",")
		end
		require("rooter").reg_callback(update_ctags_option)
	end,
}
