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

vim.lsp.config("racket_langserver", {
	cmd = { "racket", "-l", "racket-langserver" },
	filetypes = { "racket", "scheme" },
})

require("config.lazy")

-- Pass blink.cmp capabilities to all LSP servers
local ok, blink = pcall(require, "blink.cmp")
if ok then
	vim.lsp.config("*", {
		capabilities = blink.get_lsp_capabilities(),
	})
end

-- mason-lspconfig v2 auto-enables servers in `ensure_installed` via vim.lsp.enable().
-- Only enable servers that aren't installed via Mason here.
vim.lsp.enable({ "clangd", "racket_langserver" })

-- LSP keymaps. Defaults (0.11+): K (hover), grn (rename), gra (code action),
-- grr (references), gri (implementation), grt (type definition), gO (symbols).
vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition)
vim.keymap.set("n", "<Leader>ih", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true)
		end
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})

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
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr })
		end,
	},
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
