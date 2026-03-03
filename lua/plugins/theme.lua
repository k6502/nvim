return {
	"oskarnurm/koda.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("koda").setup({
			transparent = true, -- enable for transparent backgrounds

			-- Automatically enable highlights only for plugins installed by your plugin manager
			-- Currently supports `lazy.nvim`, `mini.deps` and `vim.pack`
			-- Disable this to load ALL available plugin highlights
			auto = false,

			cache = true, -- cache for better performance

			-- Style to be applied to different syntax groups
			-- Common use case would be to set either `italic = true` or `bold = true` for a desired group
			-- See `:help nvim_set_hl` for more valid values
			styles = {
				functions = { bold = true },
				keywords = {},
				comments = { italic = true },
				strings = {},
				constants = {}, -- includes numbers, booleans
			},

			-- Override colors for the active variant
			-- The color key names (e.g., 'func') must match the built-in ones
			colors = {
				-- func = "#4078F2", -- changes the color of functions
				-- keyword = "#A627A4", -- changes the color of keywords
				-- char = "#f2a4db", -- make characters pop out more by adding a different color
				--
				-- more can be found in: lua/koda/palette/
			},

			-- You can modify or extend highlight groups using the `on_highlights` configuration option
			-- Any changes made take effect when highlights are applied
			on_highlights = function(hl, c)
				-- hl.LineNr = { fg = c.info } -- change a specific highlight to use a different palette color
				-- hl.Comment = { fg = c.emphasis, italic = true } -- modify a syntax group (add bold, italic, etc)
				-- hl.RainbowDelimiterRed = { fg = "#fb2b2b" } -- add a custom highlight group for another plugin
			end,
		})
	end,
}
