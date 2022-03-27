let b:ale_powershell_powershell_executable = 'pwsh'
let b:ale_powershell_psscriptanalyzer_executable = 'pwsh'
let b:ale_powershell_psscriptanalyzer_exclusions =   'PSAvoidUsingCmdletAliases'
let b:ale_fixers= ['psscriptanalyzer','remove_trailing_lines', 'trim_whitespace']
