-- Add Mason bin to PATH early (and TeX Live on Windows)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local sysname = vim.uv.os_uname().sysname
local path_sep = sysname == "Windows_NT" and ";" or ":"

vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH

if sysname == "Windows_NT" then
	vim.env.PATH = "C:/texlive/2026/bin/windows" .. path_sep .. vim.env.PATH
end

vim.g.mapleader = ";"

-- Disable netrw before loading plugins (required for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.use_eink = vim.env.eink_screen == "1"

-- LSP server settings (register before vim.lsp.enable() in lazy.lua)
vim.lsp.config("lua_ls", {
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

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				autoImportCompletions = false,
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

vim.lsp.config("clangd", {
	cmd = { "clangd", "--clang-tidy", "--inlay-hints" },
})

require("config.lazy")

vim.o.list = true

-- 设置写入文件编码
vim.o.fileencodings = "utf-8,gb18030,cp950,euc-tw"

-- 文件类型选项
vim.g.sql_type_default = "mysql"

-- diff
vim.opt.diffopt:append("horizontal,algorithm:patience,followwrap")

-- 增加检索路径
vim.opt.path:append({
	vim.env.HOME .. "/opt/bin",
	vim.env.HOME .. "/opt/python/bin",
	vim.env.HOME .. "/.local/bin",
	vim.env.HOME .. "/opt/include",
})

vim.o.clipboard = "unnamed"

--备份文件
vim.o.backup = true
local back_dir = vim.fn.stdpath("data") .. "/backup/"
if vim.fn.isdirectory(back_dir) == 0 then
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
vim.o.completeopt = "menuone,noselect,fuzzy,popup"

-- 输入路径时自动触发 <C-x><C-f> 补全
vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		if vim.fn.pumvisible() == 1 or vim.v.char ~= "/" then
			return
		end
		local col = vim.fn.col(".") - 1
		if col == 0 then
			return
		end
		local ch = vim.api.nvim_get_current_line():sub(col, col)
		if ch:match("[%.%w_~%-]") then
			vim.schedule(function()
				vim.api.nvim_feedkeys(vim.keycode("<C-x><C-f>"), "m", false)
			end)
		end
	end,
})
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

if vim.g.use_eink then
	vim.cmd.colorscheme("eink")
else
	vim.o.background = "dark"
	vim.cmd.colorscheme("gruvbox")
end

-- Diagnostic virtual lines (Neovim 0.11+)
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { only_current_line = true },
})

-- BufReadPost: auto-set fenc to utf-8, jump to last position
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		if vim.bo.modifiable and vim.bo.fileencoding ~= "utf-8" then
			vim.bo.fileencoding = "utf-8"
		end
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line = mark[1]
		if line > 1 and line <= vim.api.nvim_buf_line_count(0) then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- Spell checking
local config_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ":p:h")
local spellfile = config_dir .. "/spell/cyymine.utf-8.add"
if vim.fn.filereadable(spellfile) == 1 then
	local splfile = spellfile .. ".spl"
	if vim.fn.filereadable(splfile) == 0 or vim.fn.getftime(spellfile) > vim.fn.getftime(splfile) then
		vim.cmd("mkspell! " .. vim.fn.fnameescape(spellfile))
	end
end
vim.o.spellfile = spellfile
vim.o.spell = true
vim.o.spelllang = "en,cjk,cyymine"
