vim.opt.termguicolors = false

local normal_groups = { 'Normal', 'Constant', 'Delimiter', 'Special', 'Directory', 'LineNR', 'Type' }
for _, group in ipairs(normal_groups) do
	vim.api.nvim_set_hl(0, group, { ctermfg = 'black', ctermbg = 'white', fg = 'black', bg = 'white' })
end

local bold_groups = { 'Pmenu', 'Identifier', 'PreProc', 'Statement' }
for _, group in ipairs(bold_groups) do
	vim.api.nvim_set_hl(0, group, { bold = true, ctermfg = 'black', ctermbg = 'white', fg = 'black', bg = 'white' })
end

if not vim.fn.has('win32') then
	vim.api.nvim_set_hl(0, 'Search', { ctermfg = 'white', ctermbg = 'black', fg = 'white', bg = 'black' })
	vim.api.nvim_set_hl(0, 'IncSearch', { ctermfg = 'white', ctermbg = 'black', fg = 'white', bg = 'black' })
end

vim.api.nvim_set_hl(0, 'Comment', { ctermfg = 'black', ctermbg = 'white', fg = 'black', bg = 'white' })

local underline_groups = { 'SpellBad', 'SpellCap', 'Underlined' }
for _, group in ipairs(underline_groups) do
	vim.api.nvim_set_hl(0, group, { underline = true, ctermfg = 'black', ctermbg = 'white', fg = 'black', bg = 'white' })
end
