-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"c",
						"lua",
						"vim",
						"vimdoc",
						"query",
						"bash",
						"bibtex",
						"cmake",
						"comment",
						"cpp",
						"cuda",
						"diff",
						"dockerfile",
						"fish",
						"go",
						"json",
						"python",
						"scheme",
						"thrift",
						"yaml",
						"latex",
					},
					auto_install = true,
					sync_install = false,
					highlight = { enable = not vim.g.use_eink },
					indent = { enable = true },
				})
			end,
		},
		{ "ntpeters/vim-better-whitespace" },
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },

		{ "wellle/targets.vim" },
		{ "dstein64/vim-startuptime" },
		{ "jiangmiao/auto-pairs" },

		{
			"vim-airline/vim-airline",
			init = function()
				vim.g.airline_section_b = ""
				vim.g.airline_section_x = ""
				vim.g.airline_extensions = {}
			end,
		},

		{
			"cyyever/ale",
			branch = "cyy",
			init = function()
				vim.g.ale_lint_on_text_changed = "never"
				vim.g.ale_echo_msg_format = "[%linter%] %code: %%s"
				vim.g.ale_fixers = { ["*"] = { "remove_trailing_lines", "trim_whitespace" } }
				vim.g.ale_fix_on_save = 1
				vim.g.ale_open_list = 1
				vim.g.ale_list_window_size = 5
				vim.g.ale_linter_aliases = { ["ps1"] = "powershell" }
			end,

			config = function(plugin)
				local mygroup = vim.api.nvim_create_augroup("CloseLoclistWindowGroup", { clear = true })
				vim.api.nvim_create_autocmd(
					{ "QuitPre" },
					{ group = mygroup, command = "if empty(&buftype) | lclose | endif" }
				)
			end,
		},
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		-- {
		-- 	"nvim-tree/nvim-tree.lua",
		-- 	version = "*",
		-- 	lazy = false,
		-- 	dependencies = {
		-- 		"nvim-tree/nvim-web-devicons", -- optional
		-- 	},
		-- 	config = function(plugin)
		-- 		require("nvim-tree").setup({})
		-- 		vim.keymap.set("n", "<Leader>f", "<cmd>NvimTreeFindFile<cr>")
		-- 	end,
		-- },

		{
			"neoclide/coc.nvim",
			branch = "release",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			build = function()
				vim.cmd(
					"CocInstall coc-clangd coc-pyright coc-cmake coc-vimtex coc-powershell coc-vimlsp coc-json coc-git coc-fish"
				)
			end,
			config = function(plugin)
				vim.keymap.set("n", "<Leader>d", '<cmd>call CocActionAsync("jumpDefinition")<cr>')
				vim.keymap.set("n", "<Leader>r", '<cmd>call CocActionAsync("jumpReferences")<cr>')
				vim.keymap.set("n", "<Leader>s", '<cmd>call CocActionAsync("doHover")<cr>')
			end,
		},
		{
			"lervag/vimtex",
			lazy = false, -- we don't want to lazy load VimTeX
			init = function()
				vim.g.vimtex_syntax_enabled = false
				-- vim.g.tex_flavor = "latex"
				vim.g.vimtex_compiler_engine = "lualatex"
				vim.g.vimtex_compiler_latexmk = {
					["callback"] = 1,
					["continuous"] = 1,
					["aux_dir"] = ".build",
					["out_dir"] = ".out",
					["executable"] = "latexmk",
					["hooks"] = {},
					["options"] = {
						"-verbose",
						"-file-line-error",
						"-synctex=1",
						"-interaction=nonstopmode",
					},
				}
				if vim.loop.os_uname().sysname == "Windows_NT" then
					vim.g.vimtex_view_general_viewer = "SumatraPDF"
					vim.g.vimtex_view_general_options = "-zoom 200 -reuse-instance -forward-search @tex @line @pdf"
				end
				if vim.loop.os_uname().sysname == "Linux" then
					vim.g.vimtex_view_method = "zathura_simple"
					vim.g.vimtex_view_zathura_simple_options = "-c ~/opt/cli_tool_configs"
				end
				if vim.loop.os_uname().sysname == "Darwin" then
					vim.g.vimtex_view_method = "sioyek"
					vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
				end
			end,
			config = function(plugin)
				local mygroup = vim.api.nvim_create_augroup("vimtex_config", { clear = true })
				vim.api.nvim_create_autocmd(
					"User",
					{ pattern = "VimtexEventInitPost", group = mygroup, command = "VimtexCompile" }
				)
				vim.keymap.set("n", "<Leader>v", "<cmd>VimtexView<cr>")
			end,
		},
		{
			"psliwka/vim-dirtytalk",
			build = ":DirtytalkUpdate",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = false },
})
