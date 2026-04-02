local M = {}

function M.add_main()
	vim.api.nvim_buf_set_lines(0, 0, 0, false, {
		"int main(int argc, char **argv)",
		"{",
		"\treturn 0;",
		"}",
	})
end

function M.split_file_with_suffix(suffix_list)
	local base = vim.fn.expand("%:p:r")
	for _, suffix in ipairs(suffix_list) do
		local path = base .. "." .. suffix
		if vim.fn.filereadable(path) == 1 and vim.fn.bufloaded(path) == 0 then
			vim.cmd.write()
			vim.cmd.split(path)
		end
	end
end

function M.comment_header()
	local ft = vim.bo.filetype
	local begin_s, mid, end_s

	if ft == "c" or ft == "cpp" then
		begin_s, mid, end_s = "/*!", " *", " */"
	elseif ft == "vim" then
		begin_s, mid, end_s = '"', '"', '"'
	elseif ft == "sh" or ft == "perl" then
		begin_s, mid, end_s = "#", "#", "#"
	else
		return
	end

	vim.api.nvim_buf_set_lines(0, 0, 0, false, {
		begin_s,
		mid .. " \\file " .. vim.fn.expand("%:t"),
		mid,
		mid .. " \\brief",
		end_s,
	})
end

return M
