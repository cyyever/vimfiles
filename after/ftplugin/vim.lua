vim.keymap.set("n", "<F2>", function()
	require("util").comment_header()
end, { buffer = true, desc = "Add comment header" })
