-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").setup()
				-- bash, c, lua, markdown, markdown_inline, python, query, vim, vimdoc
				-- ship as core parsers in nvim 0.13+, no need to install here.
				require("nvim-treesitter").install({
					"bibtex",
					"cmake",
					"comment",
					"cpp",
					"cuda",
					"diff",
					"dockerfile",
					"fish",
					"go",
					"tsx",
					"typescript",
					"html",
					"json",
					"jinja",
					"scheme",
					"thrift",
					"yaml",
					"latex",
				})

				vim.api.nvim_create_autocmd("FileType", {
					callback = function(args)
						if not vim.g.use_eink then
							pcall(vim.treesitter.start, args.buf)
						end
						local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
						if lang and vim.treesitter.query.get(lang, "indents") then
							vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end
					end,
				})
			end,
		},
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", event = "VeryLazy" },
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },

		{
			"echasnovski/mini.ai",
			event = "VeryLazy",
			config = function()
				local ai = require("mini.ai")
				ai.setup({
					n_lines = 500,
					custom_textobjects = {
						-- Treesitter-based text objects
						f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
						c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
						a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					},
				})
			end,
		},
		{ "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
		{ "echasnovski/mini.statusline", opts = { use_icons = true } },
		{
			"stevearc/conform.nvim",
			event = "BufWritePre",
			opts = {
				formatters_by_ft = {
					bib = { "bibclean" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					cmake = { "cmake_format" },
					diff = {}, -- preserve whitespace
					fish = { "fish_indent" },
					haskell = { "brittany" },
					html = { "prettier" },
					javascript = { "prettier" },
					json = { "fixjson" },
					jsonc = { "biome" },
					lua = { "stylua" },
					proto = { "buf" },
					ps1 = { "psscriptanalyzer" },
					python = { "ruff_format" },
					ruby = { "rufo" },
					sh = { "shfmt" },
					tex = { "latexindent" },
					toml = { "taplo" },
					yaml = { "yamlfix" },
					["_"] = { "trim_whitespace", "trim_newlines" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			},
		},
		{
			"stevearc/oil.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			lazy = false,
			keys = {
				{ "<Leader>f", "<cmd>Oil<cr>", desc = "Open parent directory" },
			},
			opts = {
				default_file_explorer = true,
			},
		},
		-- Completion
		{
			"saghen/blink.cmp",
			version = "1.*",
			opts = {
				keymap = { preset = "super-tab" },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				completion = {
					documentation = { auto_show = true },
				},
				signature = { enabled = true },
			},
		},

		-- LSP Support
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
			opts = {
				ensure_installed = {
					"basedpyright",
					"neocmake",
					"vimls",
					"jsonls",
					"fish_lsp",
					"yamlls",
					"lua_ls",
				},
				automatic_enable = true,
			},
		},
		{
			"lervag/vimtex",
			ft = { "tex", "bib" },
			init = function()
				vim.g.vimtex_syntax_enabled = false
				vim.g.tex_flavor = "latex"
				vim.g.vimtex_compiler_engine = "lualatex"
				vim.g.vimtex_compiler_latexmk = {
					callback = 1,
					continuous = 1,
					aux_dir = ".build",
					out_dir = ".out",
					executable = "latexmk",
					hooks = {},
					options = {
						"-verbose",
						"-file-line-error",
						"-synctex=1",
						"-interaction=nonstopmode",
					},
				}
				local sysname = vim.uv.os_uname().sysname
				if sysname == "Windows_NT" then
					vim.g.vimtex_view_general_viewer = "SumatraPDF"
					vim.g.vimtex_view_general_options = "-zoom 200 -reuse-instance -forward-search @tex @line @pdf"
				elseif sysname == "Linux" then
					vim.g.vimtex_view_method = "zathura_simple"
					vim.g.vimtex_view_zathura_simple_options = "-c ~/opt/cli_tool_configs"
				elseif sysname == "Darwin" then
					vim.g.vimtex_view_method = "sioyek"
					vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
				end
			end,
			config = function()
				local mygroup = vim.api.nvim_create_augroup("vimtex_config", { clear = true })
				vim.api.nvim_create_autocmd("User", {
					pattern = "VimtexEventInitPost",
					group = mygroup,
					callback = function()
						if vim.bo.filetype == "tex" then
							vim.cmd("VimtexCompile")
						end
					end,
				})
				vim.keymap.set("n", "<Leader>v", "<cmd>VimtexView<cr>")
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			ft = { "markdown" },
			opts = {},
		},
		{
			"psliwka/vim-dirtytalk",
			-- Nvim 0.13 dropped autoload/spellfile.vim, breaking :DirtytalkUpdate
			-- (it calls spellfile#WritableSpellDir → E117). Build the .spl from
			-- the plugin's wordlists ourselves.
			build = function(plugin)
				local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
				vim.fn.mkdir(spell_dir, "p")
				local words = {}
				for _, f in ipairs(vim.fn.glob(plugin.dir .. "/wordlists/*.words", true, true)) do
					vim.list_extend(words, vim.fn.readfile(f))
				end
				local tmp = vim.fn.tempname()
				vim.fn.writefile(words, tmp)
				vim.cmd(
					"mkspell! "
						.. vim.fn.fnameescape(spell_dir .. "/programming")
						.. " "
						.. vim.fn.fnameescape(tmp)
				)
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = false },
})
