runtime! debian.vim

" Coincidencias
set showmatch

" Ignorar mayúsculas
set ignorecase

" Mostrar número de linea
set number 
 
" Busqueda
set hlsearch 
set incsearch

" Tabulado
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
"set shellcmdflag=-ic

" Esquema de color
syntax enable
set t_Co=256
set background=dark
set termguicolors
"colorscheme Sunburst
colorscheme breezy

" Columna divisoria de 80 carácteres
set colorcolumn=80

" Encoding
set encoding=utf-8

" Tabulación para archivos HTML
autocmd BufRead,BufNewFile *.htm,*.html,*.css,*.js setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Corrector ortográfico y ajuste de líneas para los mensajes de commit de git
"set smartindent
"set wrap
"autocmd Filetype gitcommit setlocal spell textwidth=72

" Sintaxis
if has("autocmd")
  syntax on
endif

" Para cargar correctamente los plugins
if has ("autocmd")
  filetype plugin indent on
endif

" Abrir archivo en la última linea editada 
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Ejecutar en la shell el texto de la linea actual
nmap <F6> :exec '!'.getline('.')<CR>


" PLUGIN CONFIGURATIONS

" Ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsListSnippets = "<c-l>"

" NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeMapOpenInTab = 't'
let NERDTreeIgnore=['\.pyc$', '\~$'] 

" NERDTree File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py', 'lightgreen', 'none', 'lightgreen', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'lightblue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('sql', 'brown', 'none', 'brown', '#151515')

" Riv.vim
" " quote cmd with '"', special key must contain '\'
" let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=snipMate#TriggerSnippet()\<cr>"
" riv deshabilitar folding
" set nofoldenable
let g:riv_disable_folding = 1

" YouCompleteMe
"let g:ycm_server_python_interpreter='/usr/bin/python3'
"let g:ycm_key_list_select_completion = ['<Down>']
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "ᐅ"

" VimCompletesMe
"autocmd FileType vim let b:vcm_tab_complete = 'vim'
"
" Python-Syntax
let g:python_highlight_all = 1

" Emmet
" Enable emmet just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" Change the hotkey to complete emmet shorcut
let g:user_emmet_leader_key = '<c-e>'
" tow spaces in emmet completition
let g:user_emmet_settings = {
      \  'html' : {
      \    'indentation' : '  '
      \  },
      \  'css' : {
      \    'indentation' : '  '
      \  }
      \}

" SimpylFold
" Enabl folding
set foldmethod=indent
set foldlevel=99
set nu
set encoding=utf-8
" Enable folding with the spacebar
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

"OTROS

" Ofuscar contraseñas
set concealcursor=v
set conceallevel=1

" :[Pp]ass.*
autocmd FileType rst autocmd BufEnter * syn match rstpass /\%(^\s*:[Pp]ass.*:\s*\)\@<=\S\+/ conceal cchar=* containedin=ALL

" (user/pwd)
autocmd FileType rst autocmd BufEnter * syn match rstpass2 /\%(\s*(.[^/]*\/\)\@<=\S[^\)]*/ conceal cchar=* containedin=ALL

" /p:----
autocmd FileType rst autocmd BufEnter * syn match rdppass /\%(\s*\/[p]:\s*\)\@<=\S\+/ conceal cchar=* containedin=ALL
