vim.o.encoding = "utf-8"

config = vim.env.MYVIMRC
config_dir = vim.fn.fnamemodify(config, ":p:h")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles/after")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles")
vim.o.packpath = vim.o.runtimepath

if vim.fn.exists("$eink_screen") and vim.env.eink_screen == 1 then
	vim.g.use_eink = 1
else
	vim.g.use_eink = 0
end

vim.g.mapleader = ";"

-- 设置写入文件编码
vim.o.fileencodings = "utf-8,gb18030,cp950,euc-tw"
vim.o.fileencoding = "utf-8"

-- 文件类型选项
vim.g.sql_type_default = "mysql"
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

-- diff
vim.opt.diffopt:append("horizontal,algorithm:patience")

-- 增加检索路径
vim.opt.path:append(vim.env.HOME .. "/opt/bin")
vim.opt.path:append(vim.env.HOME .. "/opt/include")

vim.o.clipboard = "unnamed"

--备份文件
vim.o.backup = true
back_dir = vim.fn.stdpath("data") .. "/backup/"
if not vim.fn.isdirectory(back_dir) then
	vim.fn.mkdir(back_dir)
end
vim.o.backupdir = back_dir
--设置页号
vim.o.number = true

--缩进宽度
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

--关键字搜索当前目录

vim.opt.complete:append("k*")

-- 补全选项
vim.o.wildignorecase = true
vim.o.infercase = true

--检索时的大小写处理
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tagcase = "match"

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

vim.g.loaded_netrw = "1"
vim.g.loaded_netrwPlugin = "1"

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
		config = function()
			vim.keymap.set("n", "<Leader>f", "<cmd>NvimTreeFindFile<cr>")
		end,
	})
	use({
		"PProvost/vim-ps1",
		ft = "ps1",
	})

	use({
		"luochen1990/rainbow",
		cond = function()
			return vim.g.use_eink == 0
		end,
	})
	use({
		"ntpeters/vim-better-whitespace",
		cond = function()
			return vim.g.use_eink == 0
		end,
	})

	use({
		"morhetz/gruvbox",
		cond = function()
			return vim.g.use_eink == 0
		end,
		setup = function()
			vim.g.gruvbox_italic = 1
		end,
		config = function()
			vim.cmd("colorscheme gruvbox")
		end,
	})
	use({
		"neoclide/coc.nvim",
		branch = "release",
		run = function()
			vim.cmd("CocInstall coc-clangd coc-pyright coc-cmake coc-vimtex coc-powershell coc-vimlsp")
		end,
		config = function()
			vim.keymap.set("n", "<Leader>d", '<cmd>call CocActionAsync("jumpDefinition")<cr>')
			vim.keymap.set("n", "<Leader>r", '<cmd>call CocActionAsync("jumpReferences")<cr>')
			vim.keymap.set("n", "<Leader>s", '<cmd>call CocActionAsync("doHover")<cr>')
		end,
	})
	use({
		"vim-airline/vim-airline",
		setup = function()
			vim.g.airline_section_b = ""
			vim.g.airline_section_x = ""
			vim.g.airline_extensions = {}
		end,
	})
	use({
		"lervag/vimtex",
		setup = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_compiler_latexmk = {
				["callback"] = 1,
				["continuous"] = 1,
				["executable"] = "latexmk",
				["hooks"] = {},
				["options"] = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
			if vim.fn.has("win32") then
				vim.g.vimtex_view_general_viewer = "SumatraPDF"
				vim.g.vimtex_view_general_options = "-zoom 200 -reuse-instance -forward-search @tex @line @pdf"
			end
			if vim.loop.os_uname().sysname == "Linux" then
				vim.g.vimtex_view_method = "zathura"
				vim.g.vimtex_view_zathura_options = "-c ~/opt/cli_tool_configs"
			end
			if vim.loop.os_uname().sysname == "Darwin" then
				vim.g.vimtex_view_method = "sioyek"
				vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
			end
		end,
		config = function()
			local mygroup = vim.api.nvim_create_augroup("vimtex_config", { clear = true })
			vim.api.nvim_create_autocmd(
				"User",
				{ pattern = "VimtexEventInitPost", group = mygroup, command = "VimtexCompile" }
			)
			vim.keymap.set("n", "<Leader>v", "<cmd>VimtexView<cr>")
		end,
		ft = "tex",
	})
	use({
		"cyyever/ale",
		branch = "cyy",
		setup = function()
			vim.g.ale_lint_on_text_changed = "never"
			vim.g.ale_echo_msg_format = "[%linter%] %code: %%s"
			vim.g.ale_fixers = { ["*"] = { "remove_trailing_lines", "trim_whitespace" } }
			vim.g.ale_fix_on_save = 1
			vim.g.ale_open_list = 1
			vim.g.ale_list_window_size = 5
			vim.g.ale_linter_aliases = { ["ps1"] = "powershell" }
		end,

		config = function()
			local mygroup = vim.api.nvim_create_augroup("CloseLoclistWindowGroup", { clear = true })
			vim.api.nvim_create_autocmd(
				{ "QuitPre" },
				{ group = mygroup, command = "if empty(&buftype) | lclose | endif" }
			)
		end,
	})
	use("tpope/vim-commentary")
	use("wellle/targets.vim")
	use("dstein64/vim-startuptime")
	use("jiangmiao/auto-pairs")
end)
config_update_tag_path = config_dir .. "/.update_tag"
if
	not vim.fn.filereadable(config_update_tag_path)
	or vim.fn.localtime() > vim.fn.getftime(config_update_tag_path) + 3600 * 24 * 30
then
	vim.cmd("PackerSync")
	vim.fn.writefile({}, config_update_tag_path)
end

if vim.g.use_eink == 0 then
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		ignore_install = { "latex" },
		auto_install = true,
		highlight = {
			enable = true,
			disable = { "latex" },

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
	})
else
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		auto_install = true,
		highlight = {
			enable = false,

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
	})
end
require("nvim-tree").setup()

-- provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

if vim.fn.has("win32") then
	vim.g.python3_host_prog = vim.fn.exepath("python")
end

vim.o.mouse = "r"

vim.cmd("source " .. config_dir .. "/vimfiles/vimrc")

if vim.g.use_eink == 1 then
	vim.cmd("colorscheme eink")
end
