-- Enable Lua module caching for faster startup (Neovim 0.11+)
vim.loader.enable()

-- Add Mason bin to PATH early (and TeX Live on Windows)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local sysname = vim.uv.os_uname().sysname
local path_sep = sysname == "Windows_NT" and ";" or ":"

vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH

if sysname == "Windows_NT" then
	vim.env.PATH = "C:/texlive/2026/bin/windows" .. path_sep .. vim.env.PATH
end

vim.o.fileformats = "unix,dos"
vim.g.mapleader = ";"

-- Disable netrw before loading plugins (required for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

local config = vim.env.MYVIMRC
local config_dir = vim.fn.fnamemodify(config, ":p:h")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles/after")
vim.opt.runtimepath:prepend(config_dir .. "/vimfiles")
vim.o.packpath = vim.o.runtimepath

vim.g.use_eink = vim.env.eink_screen == "1" and 1 or 0

vim.o.list = true

-- 设置写入文件编码
vim.o.fileencodings = "utf-8,gb18030,cp950,euc-tw"
vim.o.fileencoding = "utf-8"

-- 文件类型选项
vim.g.sql_type_default = "mysql"

-- diff
vim.opt.diffopt:append("horizontal,algorithm:patience")

-- 增加检索路径
vim.opt.path:append(vim.env.HOME .. "/opt/bin")
vim.opt.path:append(vim.env.HOME .. "/opt/python/bin")
vim.opt.path:append(vim.env.HOME .. "/.local/bin")
vim.opt.path:append(vim.env.HOME .. "/opt/include")

vim.o.clipboard = "unnamed"

--备份文件
vim.o.backup = true
local back_dir = vim.fn.stdpath("data") .. "/backup/"
if not vim.fn.isdirectory(back_dir) then
	vim.fn.mkdir(back_dir)
end
vim.o.backupdir = back_dir
--设置页号
vim.o.number = true

--缩进宽度
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

-- Smooth scrolling (Neovim 0.11+)
vim.o.smoothscroll = true

-- Treesitter folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99 -- Start with all folds open
vim.o.foldlevelstart = 99

vim.keymap.set("n", "n", "nzz")

-- Snippet navigation (Neovim 0.11+)
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if vim.snippet.active({ direction = 1 }) then
		return "<cmd>lua vim.snippet.jump(1)<cr>"
	else
		return "<Tab>"
	end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<cmd>lua vim.snippet.jump(-1)<cr>"
	else
		return "<S-Tab>"
	end
end, { expr = true })

-- 补全选项
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.wildignorecase = true
vim.o.infercase = true

--检索时的大小写处理
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tagcase = "match"

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.o.mouse = "r"
-- 颜色方案
vim.o.termguicolors = true

if vim.g.use_eink == 1 then
	vim.cmd([[colorscheme eink]])
else
	vim.o.background = "dark" -- or "light" for light mode
	vim.cmd([[colorscheme gruvbox]])
end

-- Diagnostic virtual lines (Neovim 0.11+)
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { only_current_line = true },
})

-- Auto-set fenc to utf-8 for modifiable buffers
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		if vim.bo.modifiable and vim.bo.fileencoding ~= "utf-8" then
			vim.bo.fileencoding = "utf-8"
		end
	end,
})

-- Wrap lines in diff mode
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.wo.diff then
			vim.cmd("windo set wrap")
		end
	end,
})

-- Jump to last position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line = mark[1]
		if line > 1 and line <= vim.api.nvim_buf_line_count(0) then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- Spell checking
local spellfile = config_dir .. "/vimfiles/spell/cyymine.utf-8.add"
if vim.fn.filereadable(spellfile) == 1 then
	local splfile = spellfile .. ".spl"
	if vim.fn.filereadable(splfile) == 0 or vim.fn.getftime(spellfile) > vim.fn.getftime(splfile) then
		vim.cmd("mkspell! " .. vim.fn.fnameescape(spellfile))
	end
end
vim.o.spellfile = spellfile
vim.o.spell = true
vim.o.spelllang = "en,cjk,cyymine"

-- Override lua_ls cmd after all plugins loaded (nvim-lspconfig defaults)
local mason_packages = vim.fn.stdpath("data") .. "/mason/packages/"
local lua_ls_exe = mason_packages .. "lua-language-server/bin/lua-language-server"
if vim.uv.os_uname().sysname == "Windows_NT" then
	lua_ls_exe = lua_ls_exe .. ".exe"
end
vim.lsp.config("lua_ls", {
	cmd = { lua_ls_exe },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			hint = { enable = true },
		},
	},
})

-- Enable inlay hints for basedpyright
vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				autoImportCompletions = false, -- better performance
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
					callArgumentNames = true,
					genericTypes = true,
				},
			},
		},
	},
})

-- Enable inlay hints for clangd
vim.lsp.config("clangd", {
	cmd = { "clangd", "--clang-tidy", "--inlay-hints" },
})
