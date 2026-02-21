return {
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = {
			"saghen/blink.compat",
			"rafamadriz/friendly-snippets",
			{
				"Fildo7525/pretty_hover",
				event = "LspAttach",
				opts = {},
			},
			{
				"sontungexpt/better-diagnostic-virtual-text",
				event = "LspAttach",
				config = function(_)
					require("better-diagnostic-virtual-text").setup(opts)
				end,
			},
			{
				"mason-org/mason.nvim",
				dependencies = {
					"mason-org/mason-lspconfig.nvim",
					"neovim/nvim-lspconfig",
					"WhoIsSethDaniel/mason-tool-installer.nvim",
					"mfussenegger/nvim-dap",
					"jay-babu/mason-nvim-dap.nvim",
				},
				config = function()
					require("mason").setup({
						max_concurrent_installers = 12,
						pip = {
							---@since 1.0.0
							-- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
							upgrade_pip = true,
						},
					})
					require("mason-nvim-dap").setup()
					require("mason-lspconfig").setup({
						ensure_installed = { "lua_ls", "clangd", "rust_analyzer" },
					})
					require("mason-tool-installer").setup({
						ensure_installed = {
							"stylua",
							"selene",
							"cpplint",
							"clang-format",
							"bacon",
						},
						auto_update = true,
					})
				end,
			},
		},

		build = "cargo build --release", ---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			-- "default" (recommended) for mappings similar to built-in completions (C-y to accept)
			-- "super-tab" for mappings similar to vscode (tab to accept)
			-- "enter" for enter to accept
			-- "none" for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "super-tab" },

			appearance = {
				-- "mono" (default) for "Nerd Font Mono" or "normal" for "Nerd Font"
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "normal",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				keyword = { range = "full" },
				menu = { enabled = true, draw = { align_to = "cursor", treesitter = { "lsp" } } },
				ghost_text = { enabled = true },
				documentation = {
					auto_show = true,
					draw = function(opts)
						if opts.item and opts.item.documentation and opts.item.documentation.value then
							local out = require("pretty_hover.parser").parse(opts.item.documentation.value)
							opts.item.documentation.value = out:string()
						end

						opts.default_implementation(opts)
					end,
				},
			},

			signature = {
				enabled = true,
				trigger = {
					-- Show the signature help automatically
					enabled = true,
					-- Show the signature help window after typing any of alphanumerics, `-` or `_`
					show_on_keyword = true,
					blocked_trigger_characters = {},
					blocked_retrigger_characters = {},
					-- Show the signature help window after typing a trigger character
					show_on_trigger_character = true,
					-- Show the signature help window when entering insert mode
					show_on_insert = true,
					-- Show the signature help window when the cursor comes after a trigger character when entering insert mode
					show_on_insert_on_trigger_character = true,
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "cmdline", "omni", "markview" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "rust", sorts = { "exact", "score", "sort_text" } },
			term = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
}
