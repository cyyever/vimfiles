if filereadable(getcwd().'/compile_commands.json')
	call coc#config('clangd.compilationDatabasePath', getcwd() )
endif
