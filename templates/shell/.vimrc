runtime! debian.vim

call plug#begin()
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' }
Plug 'phenomenes/ansible-snippets'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ervandew/supertab'
call plug#end()

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
"colorscheme breezy
colorscheme nord 

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
nmap <F6> :exec '!runcommand '.getline('.')<CR>


" ===========================================================================
" PLUGIN CONFIGURATIONS
" ===========================================================================

" YouCompleteMe
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Ultisnips
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeLimitedSyntax = 1
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

" Autopairs
let g:AutoPairsShortcutFastWrap = '<M-y>'
let g:AutoPairsShortcutToggle = '<M-F5>'


"OTROS

" Ofuscar contraseñas
set concealcursor=v
set conceallevel=1

" :[Pp]ass.*
autocmd FileType rst autocmd BufEnter * syn match rstpass /\%(^\s*:[Pp]ass.*:\s*\)\@<=\S\+/ conceal cchar=* containedin=ALL

" (user/pwd)
autocmd FileType rst autocmd BufEnter * syn match rstpass2 /\%(\s*(.[^/]*\/\)\@<=\S[^\)]*/ conceal cchar=* containedin=ALL

" (user/pwd)
autocmd FileType rst autocmd BufEnter * syn match rstpass2 /\%(\s*(.[^/]*::\)\@<=\S[^\)]*/ conceal cchar=* containedin=ALL

" /p:----
autocmd FileType rst autocmd BufEnter * syn match rdppass /\%(\s*\/[p]:\s*\)\@<=\S\+/ conceal cchar=* containedin=ALL


" Yaml identation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab


" IdentLine
let g:indentLine_char = '⦙'


" ALE
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'


" ANSIBLE
let g:ansible_unindent_after_newline = 1
let g:ansible_yamlKeyName = 'yamlKey'
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/colors/yaml.vim
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_extra_keywords_highlight_group = 'Statement'
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_loop_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.rb.j2': 'ruby' }
let g:ansible_ftdetect_filename_regex = '\v(playbook|site|main|local|requirements)\.ya?ml$'
