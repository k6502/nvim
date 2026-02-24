return {
	"nvim-neorg/neorg",
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neorg/lua-utils.nvim",
		{
			"3rd/image.nvim",
			lazy = false,
			config = function()
				require("image").setup({
					backend = "kitty", -- or "ueberzug" or "sixel"
					processor = "magick_cli", -- or "magick_rock"
					integrations = {
						markdown = {
							enabled = true,
							clear_in_insert_mode = false,
							download_remote_images = true,
							only_render_image_at_cursor = false,
							only_render_image_at_cursor_mode = "popup", -- or "inline"
							floating_windows = true, -- if true, images will be rendered in floating markdown windows
							filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
						},
						asciidoc = {
							enabled = true,
							clear_in_insert_mode = false,
							download_remote_images = true,
							only_render_image_at_cursor = false,
							only_render_image_at_cursor_mode = "popup",
							floating_windows = false,
							filetypes = { "asciidoc", "adoc" },
						},
						neorg = {
							enabled = true,
							filetypes = { "norg" },
						},
						rst = {
							enabled = true,
						},
						typst = {
							enabled = true,
							filetypes = { "typst" },
						},
						html = {
							enabled = true,
						},
						css = {
							enabled = true,
						},
					},
					max_width = nil,
					max_height = nil,
					max_width_window_percentage = nil,
					max_height_window_percentage = 50,
					scale_factor = 1.0,
					window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
					window_overlap_clear_ft_ignore = {
						"cmp_menu",
						"cmp_docs",
						"snacks_notif",
						"scrollview",
						"scrollview_sign",
					},
					editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
					tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
					hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
				})
			end,
		},
	},
	build = ":Neorg sync-parsers",
	opts = {
		load = {
			["core.defaults"] = {}, -- Loads default behaviour
			["core.concealer"] = {}, -- Adds pretty icons to your documents
			["core.integrations.image"] = {},
			["core.latex.renderer"] = {},
			["core.dirman"] = { -- Manages Neorg workspaces
				config = {
					workspaces = {
						notes = "~/notes/",
					},
					default_workspace = "notes",
				},
			},
		},
	},
}
