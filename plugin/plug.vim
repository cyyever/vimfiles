" 插件
let g:vim_plug_dir=expand('<sfile>:p:h') . '/plugged'
call plug#begin(g:vim_plug_dir)

Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

let g:ale_lint_on_text_changed='never'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let s:languagetool_jar=$HOME.'/opt/languagetool/languagetool-commandline.jar'
if filereadable(s:languagetool_jar)
  let g:ale_languagetool_executable='java'
  let g:ale_languagetool_options='-jar '.s:languagetool_jar.' --autoDetect'
endif
let g:ale_linter_aliases = {'ps1': 'powershell'}
let g:ale_textlint_options='--rule languagetool'

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
Plug 'cyyever/ale', { 'branch': 'cyy' }


if has('win32')
  Plug 'PProvost/vim-ps1'
endif

" remove sections
let g:airline_section_b=''
let g:airline_section_x=''
let g:airline_extensions = []
Plug 'vim-airline/vim-airline'

if !has('win32')
  Plug 'dag/vim-fish'
endif


let b:coc_diagnostic_disable=1
Plug 'neoclide/coc.nvim', {'branch': 'release','do': ':CocInstall coc-clangd coc-pyright coc-cmake coc-vimtex coc-powershell'}

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('doHover')
nnoremap <Leader>d :call CocActionAsync("jumpDefinition")<CR>
nnoremap <Leader>r :call CocActionAsync("jumpReferences")<CR>
nnoremap <Leader>s :call CocActionAsync("doHover")<CR>

let g:vimtex_compiler_progname = 'nvr'

if !has('win32')
  let g:vimtex_view_method = 'zathura'
  let g:vimtex_view_zathura_options = '-c ~/opt/cli_tool_configs'
else
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options = '-zoom 200 -reuse-instance -forward-search @tex @line @pdf'
endif

let g:tex_flavor='latex'
Plug 'lervag/vimtex'
augroup vimtex_config
  autocmd!
  autocmd User VimtexEventInitPost VimtexCompile
  autocmd User VimtexEventInitPost let g:vimtex_compiler_latexmk = {'build_dir' : tempname()}
  autocmd User VimtexEventInitPost nnoremap <Leader>v :VimtexView<CR>
augroup end

if g:use_eink==0
  let g:c_no_bracket_error=1
  let g:c_no_curly_error=1
  Plug 'octol/vim-cpp-enhanced-highlight'
  let g:semshi#mark_selected_nodes=0
  " Plug 'numirias/semshi' ,{ 'do': ':UpdateRemotePlugins' }
  Plug 'cyyever/semshi' ,{ 'do': ':UpdateRemotePlugins','branch':'cyy' }
  autocmd VimEnter * if exists(":UpdateRemotePlugins") | execute 'UpdateRemotePlugins' | endif
  Plug 'ntpeters/vim-better-whitespace'
endif

let g:instant_markdown_slow = 0
let g:instant_markdown_autoscroll = 1
let g:instant_markdown_autostart = 0
let g:instant_markdown_logfile = tempname()
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

let g:fzf_action = { 'enter': 'split' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

nnoremap <Leader>sp :GFiles<CR>

if g:use_eink==0
  let g:rainbow_active=1
  Plug 'luochen1990/rainbow'
endif

Plug 'jiangmiao/auto-pairs'
Plug 'wlangstroth/vim-racket'
Plug 'voldikss/vim-mma'

Plug 'preservim/nerdtree'

nnoremap <Leader>f :NERDTreeFind<CR>

Plug 'ryanoasis/vim-devicons'

function! TreeSitterUpdate(info)
  TSUpdate bash bibtex c cpp cmake comment fish json latex yaml html python ruby rust
  TSUpdate
endfunction

Plug 'nvim-treesitter/nvim-treesitter', {'do': function('TreeSitterUpdate') }  " We recommend updating the parsers on update

call plug#end()

let s:vim_plug_update_tag_path=g:vim_plug_dir.'/.update_tag.eink.'.float2nr(g:use_eink)
if !isdirectory(g:vim_plug_dir)  || !filereadable(s:vim_plug_update_tag_path) || getftime(expand('<sfile>:p')) > getftime(s:vim_plug_update_tag_path)+3600
  PlugUpgrade
  PlugUpdate!
  call writefile([],s:vim_plug_update_tag_path)
endif
