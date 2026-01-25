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
			lazy = false,
			main = "nvim-treesitter.config",
			opts = {
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
					"tsx",
					"typescript",
					"html",
					"json",
					"jinja",
					"markdown",
					"markdown_inline",
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
			},
		},
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },

		{ "wellle/targets.vim" },
		{ "dstein64/vim-startuptime", cmd = "StartupTime" },
		{
			"echasnovski/mini.pairs",
			event = "InsertEnter",
			config = function()
				require("mini.pairs").setup()
			end,
		},
		{
			"echasnovski/mini.statusline",
			lazy = false,
			config = function()
				require("mini.statusline").setup({
					use_icons = true,
				})
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
				vim.g.ale_set_loclist = 0
				vim.g.ale_set_quickfix = 1
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
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({})
				vim.keymap.set("n", "<Leader>f", "<cmd>NvimTreeFindFile<cr>")
			end,
		},
		-- LSP Support
		{
			"williamboman/mason.nvim",
			lazy = false,
			config = function()
				require("mason").setup()
			end,
		},
		-- nvim-lspconfig provides default configs in lsp/ directory
		{ "neovim/nvim-lspconfig", lazy = false },
		{
			"williamboman/mason-lspconfig.nvim",
			lazy = false,
			dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"clangd",
						"pyright",
						"neocmake",
						"texlab",
						"vimls",
						"jsonls",
						"fish_lsp",
						"yamlls",
						"lua_ls",
					},
					automatic_installation = true,
				})

				-- Native Neovim 0.11+ LSP configuration
				-- Racket langserver (not in Mason, needs config before enable)
				vim.lsp.config("racket_langserver", {
					cmd = { "racket", "-l", "racket-langserver" },
					filetypes = { "racket", "scheme" },
				})

				-- Enable all servers (uses defaults from nvim-lspconfig/lsp/)
				vim.lsp.enable({
					"lua_ls",
					"pyright",
					"jsonls",
					"yamlls",
					"vimls",
					"texlab",
					"neocmake",
					"fish_lsp",
					"clangd",
					"racket_langserver",
				})

				-- lua_ls settings configured in init.lua (after plugins load)

				-- LSP Keymaps
				vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition)
				vim.keymap.set("n", "<Leader>r", vim.lsp.buf.references)
				vim.keymap.set("n", "<Leader>s", vim.lsp.buf.hover)
				vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
				vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

				-- LSP attach autocmd for completion
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if client and client:supports_method("textDocument/completion") then
							vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
						end
					end,
				})
			end,
		},
		{
			"lervag/vimtex",
			lazy = false, -- we don't want to lazy load VimTeX
			init = function()
				vim.g.vimtex_syntax_enabled = false
				vim.g.tex_flavor = "latex"
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
				if vim.uv.os_uname().sysname == "Windows_NT" then
					vim.g.vimtex_view_general_viewer = "SumatraPDF"
					vim.g.vimtex_view_general_options = "-zoom 200 -reuse-instance -forward-search @tex @line @pdf"
				end
				if vim.uv.os_uname().sysname == "Linux" then
					vim.g.vimtex_view_method = "zathura_simple"
					vim.g.vimtex_view_zathura_simple_options = "-c ~/opt/cli_tool_configs"
				end
				if vim.uv.os_uname().sysname == "Darwin" then
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
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
			opts = {},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = false },
})
