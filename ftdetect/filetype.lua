vim.filetype.add({
	extension = {
		thrift = 'thrift',
	},
	pattern = {
		['.*%.json%.conf'] = 'json',
		['[Vv]agrantfile'] = 'ruby',
		['[Dd]ockerfile'] = 'dockerfile',
		['[Dd]ockerfile%..*'] = 'dockerfile',
	},
})
