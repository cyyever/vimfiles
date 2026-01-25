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
			build = ":TSUpdate",
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
					markdown = { "markdownlint-cli2" },
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
					lsp_fallback = true,
				},
			},
		},
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = { { "<Leader>f", "<cmd>NvimTreeFindFile<cr>" } },
			opts = {},
		},
		-- LSP Support
		{ "williamboman/mason.nvim", opts = {} },
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						-- clangd uses system installation
						"basedpyright",
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
					"basedpyright",
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
				vim.keymap.set("n", "<Leader>ih", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end)

				-- LSP attach autocmd for completion and inlay hints
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if client then
							if client:supports_method("textDocument/completion") then
								vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
							end
							if client:supports_method("textDocument/inlayHint") then
								vim.lsp.inlay_hint.enable(true)
							end
						end
					end,
				})
			end,
		},
		{
			"lervag/vimtex",
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
				vim.api.nvim_create_autocmd(
					"User",
					{ pattern = "VimtexEventInitPost", group = mygroup, command = "VimtexCompile" }
				)
				vim.keymap.set("n", "<Leader>v", "<cmd>VimtexView<cr>")
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			ft = { "markdown" },
			opts = {},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- automatically check for plugin updates
	checker = { enabled = false },
})
