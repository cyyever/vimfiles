local util = require("util")
local ext = vim.fn.expand("%:e")

if ext == "h" then
	vim.keymap.set("n", "<F4>", function()
		util.split_file_with_suffix({ "C", "c", "cpp", "cc", "cxx" })
	end, { buffer = true, desc = "Open related source" })
else
	vim.keymap.set("n", "<F2>", util.add_main, { buffer = true, desc = "Add main()" })
	vim.keymap.set("n", "<F4>", function()
		util.split_file_with_suffix({ "h", "hpp" })
	end, { buffer = true, desc = "Open related header" })
end

vim.keymap.set("n", "<F3>", util.comment_header, { buffer = true, desc = "Add comment header" })
