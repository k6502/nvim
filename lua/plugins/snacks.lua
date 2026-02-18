return {
	"folke/snacks.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-mini/mini.icons",
		{
			"folke/persistence.nvim",
			event = "BufReadPre", -- this will only start session saving when an actual file was opened
			opts = {
				-- add any custom options here
				dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
				-- minimum number of file buffers that need to be open to save
				-- Set to 0 to always save
				need = 0,
				branch = true, -- use git branch to save session
			},
			keys = {
				-- load the session for the current directory
				vim.keymap.set("n", "<leader>qs", function()
					require("persistence").load()
				end),

				-- select a session to load
				vim.keymap.set("n", "<leader>qS", function()
					require("persistence").select()
				end),

				-- load the last session
				vim.keymap.set("n", "<leader>ql", function()
					require("persistence").load({ last = true })
				end),

				-- stop Persistence => session won't be saved on exit
				vim.keymap.set("n", "<leader>qd", function()
					require("persistence").stop()
				end),
			},
		},
	},
	priority = 1000,
	lazy = false,
	opts = {
		animate = {
			fps = 180,
			easing = "outQuart",
			duration = 200,
		},
		dim = {
			---@type snacks.scope.Config
			scope = {
				min_size = 5,
				max_size = 20,
				siblings = true,
			},
			-- animate scopes. Enabled by default for Neovim >= 0.10
			-- Works on older versions but has to trigger redraws during animation.
			---@type snacks.animate.Config|{enabled?: boolean}
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				easing = "outQuart",
				duration = {
					step = 200, -- ms per step
					total = 250, -- maximum duration
				},
			},
			-- what buffers to dim
			filter = function(buf)
				return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
			end,
		},
		bigfile = { enabled = true },
		dashboard = {
			sections = {
				{ section = "header" },
				{
					pane = 2,
					section = "terminal",
					cmd = "colorscript -e zwaves",
					height = 5,
					padding = 1,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
		explorer = { enabled = true },
		indent = {
			priority = 1,
			enabled = true,
			char = "│",
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				style = "out",
				easing = "outQuart",
				duration = {
					step = 200, -- ms per step
					total = 250, -- maximum duration
				},
			},
			chunk = {
				-- when enabled, scopes will be rendered as chunks, except for the
				-- top-level scope which will be rendered as a scope.
				enabled = true,
				-- only show chunk scopes in the current window
				only_current = false,
				priority = 200,
				hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
				char = {
					corner_top = "╭",
					corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					aarrow = "─>",
				},
			},
		},
		input = {}, -- Use defaults
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		rename = {
			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "netrw" },
				group = vim.api.nvim_create_augroup("NetrwOnRename", { clear = true }),
				callback = function()
					vim.keymap.set("n", "R", function()
						local original_file_path = vim.b.netrw_curdir .. "/" .. vim.fn["netrw#Call"]("NetrwGetWord")

						vim.ui.input(
							{ prompt = "Move/rename to:", default = original_file_path },
							function(target_file_path)
								if target_file_path and target_file_path ~= "" then
									local file_exists = vim.uv.fs_access(target_file_path, "W")

									if not file_exists then
										vim.uv.fs_rename(original_file_path, target_file_path)

										Snacks.rename.on_rename_file(original_file_path, target_file_path)
									else
										vim.notify(
											"File '" .. target_file_path .. "' already exists! Skipping...",
											vim.log.levels.ERROR
										)
									end

									-- Refresh netrw
									vim.cmd(":Ex " .. vim.b.netrw_curdir)
								end
							end
						)
					end, { remap = true, buffer = true })
				end,
			}),
		},
		picker = { enabled = true },
		quickfile = { enabled = true },
		scope = {
			-- absolute minimum size of the scope.
			-- can be less if the scope is a top-level single line scope
			min_size = 2,
			-- try to expand the scope to this size
			max_size = nil,
			cursor = true, -- when true, the column of the cursor is used to determine the scope
			edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
			siblings = true, -- expand single line scopes with single line siblings
			-- what buffers to attach to
			filter = function(buf)
				return vim.bo[buf].buftype == "" and vim.b[buf].snacks_scope ~= false and vim.g.snacks_scope ~= false
			end,
			-- debounce scope detection in ms
			debounce = 30,
			treesitter = {
				-- detect scope based on treesitter.
				-- falls back to indent based detection if not available
				enabled = true,
				injections = true, -- include language injections when detecting scope (useful for languages like `vue`)
				---@type string[]|{enabled?:boolean}
				blocks = {
					enabled = true, -- enable to use the following blocks
					"function_declaration",
					"function_definition",
					"method_declaration",
					"method_definition",
					"class_declaration",
					"class_definition",
					"do_statement",
					"while_statement",
					"repeat_statement",
					"if_statement",
					"for_statement",
				},
				-- these treesitter fields will be considered as blocks
				field_blocks = {
					"local_declaration",
				},
			},
		},
		scroll = {
			animate = {
				duration = { step = 200, total = 250 },
				easing = "outQuart",
			},
			-- faster animation when repeating scroll after delay
			animate_repeat = {
				delay = 100, -- delay in ms before using the repeat animation
				duration = { step = 5, total = 50 },
				easing = "outQuart",
			},
			-- what buffers to animate
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
			end,
		},
		statuscolumn = { enabled = true },
		words = {
			debounce = 200, -- time in ms to wait before updating
			notify_jump = false, -- show a notification when jumping
			notify_end = true, -- show a notification when reaching the end
			foldopen = true, -- open folds after jumping
			jumplist = true, -- set jump point before jumping
			modes = { "n", "i", "c" }, -- modes to show references
			filter = function(buf) -- what buffers to enable `snacks.words`
				return vim.g.snacks_words ~= false and vim.b[buf].snacks_words ~= false
			end,
		},
		styles = {
			notification = {
				wo = { wrap = true }, -- Wrap notifications
			},
		},
		image = {
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				"pdf",
				"icns",
			},
			force = false, -- try displaying the image, even if the terminal does not support it
			doc = {
				-- enable image viewer for documents
				-- a treesitter parser must be available for the enabled languages.
				enabled = true,
				-- render the image inline in the buffer
				-- if your env doesn't support unicode placeholders, this will be disabled
				-- takes precedence over `opts.float` on supported terminals
				inline = true,
				-- render the image in a floating window
				-- only used if `opts.inline` is disabled
				float = true,
				max_width = 80,
				max_height = 40,
				-- Set to `true`, to conceal the image text when rendering inline.
				-- (experimental)
				---@param lang string tree-sitter language
				---@param type snacks.image.Type image type
				conceal = function(lang, type)
					-- only conceal math expressions
					return type == "math"
				end,
			},
			img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
			-- window options applied to windows displaying image buffers
			-- an image buffer is a buffer with `filetype=image`
			wo = {
				wrap = false,
				number = false,
				relativenumber = false,
				cursorcolumn = false,
				signcolumn = "no",
				foldcolumn = "0",
				list = false,
				spell = false,
				statuscolumn = "",
			},
			cache = vim.fn.stdpath("cache") .. "/snacks/image",
			debug = {
				request = false,
				convert = false,
				placement = false,
			},
			env = {},
			-- icons used to show where an inline image is located that is
			-- rendered below the text.
			icons = {
				math = "󰪚 ",
				chart = "󰄧 ",
				image = " ",
			},
			---@class snacks.image.convert.Config
			convert = {
				notify = false, -- show a notification on error
				---@type snacks.image.args
				mermaid = function()
					local theme = vim.o.background == "light" and "neutral" or "dark"
					return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
				end,
				---@type table<string,snacks.image.args>
				magick = {
					default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
					vector = { "-density", 192, "{src}[{page}]" }, -- used by vector images like svg
					math = { "-density", 192, "{src}[{page}]", "-trim" },
					pdf = { "-density", 192, "{src}[{page}]", "-background", "white", "-alpha", "remove", "-trim" },
				},
			},
			math = {
				enabled = true, -- enable math expression rendering
				-- in the templates below, `${header}` comes from any section in your document,
				-- between a start/end header comment. Comment syntax is language-specific.
				-- * start comment: `// snacks: header start`
				-- * end comment:   `// snacks: header end`
				typst = {
					tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
				},
				latex = {
					font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
					-- for latex documents, the doc packages are included automatically,
					-- but you can add more packages here. Useful for markdown documents.
					packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
					tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
				},
			},
		},
	},
	keys = {
		-- Top Pickers & Explorer
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		-- find
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Find Git Files",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		-- git
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_line()
			end,
			desc = "Git Log Line",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Log File",
		},
		-- gh
		{
			"<leader>gi",
			function()
				Snacks.picker.gh_issue()
			end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function()
				Snacks.picker.gh_issue({ state = "all" })
			end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
		-- Grep
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		-- search
		{
			'<leader>s"',
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>si",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Search for Plugin Spec",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>uC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes",
		},
		-- LSP
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto T[y]pe Definition",
		},
		{
			"gai",
			function()
				Snacks.picker.lsp_incoming_calls()
			end,
			desc = "C[a]lls Incoming",
		},
		{
			"gao",
			function()
				Snacks.picker.lsp_outgoing_calls()
			end,
			desc = "C[a]lls Outgoing",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		-- Other
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>Z",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle Zoom",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
		{
			"<c-_>",
			function()
				Snacks.terminal()
			end,
			desc = "which_key_ignore",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end

				-- Override print to use snacks for `:=` command
				if vim.fn.has("nvim-0.11") == 1 then
					vim._print = function(_, ...)
						dd(...)
					end
				else
					vim.print = _G.dd
				end
			end,
		})
	end,
}
