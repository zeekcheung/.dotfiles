let mapleader=" "
let maplocalleader=" "

" backup/swap/undo
set nobackup
set nowritebackup
set noswapfile
set undofile
set undolevels=10000
set undodir=~/.vim/undodir
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" number line
set number
set relativenumber

" indent
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent
set smartindent
set shiftround

" search
set hlsearch
set ignorecase
set smartcase
set incsearch

" scroll
set scrolloff=5
set sidescrolloff=8

" split
set splitbelow
set splitright
set splitkeep=screen

" vertical wildmenu
set wildmenu
set wildoptions=pum
set wildignorecase

" completion
set completeopt=menu,menuone,noinsert
set pumheight=10

" chars
set fillchars=eob:\ ,fold:\ ,vert:│
set listchars=tab:▸\ ,eol:¬

" cursor shape
let &t_SI.="\e[5 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[1 q"

" statusline
set laststatus=2
set statusline=%<\ %f\ %m\ %=\ \ %Y\ \ %{&fileencoding?&fileencoding:&encoding}\ \ %P\ \ %l:%c\ "

" miscellaneous
set cursorline
set mouse=a
set clipboard=unnamedplus
set autowrite
set encoding=utf-8
set ttyfast
set timeoutlen=300
set belloff=all

" colorscheme
set termguicolors
" colorscheme habamax
colorscheme tokyonight-moon

" netrw
let g:netrw_banner=0
let g:netrw_winsize=30
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_browse_style=4
let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd='cp -r'

" Better escape
inoremap <silent> jj <esc>

" Better paste
vnoremap <silent> <C-v> pgvy

" Better indenting
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Enter> pumvisible() ? "\<C-Y>" : "\<Enter>"

" Misc
vnoremap <silent> <C-c> "+y
vnoremap <silent> <C-x> "+d
inoremap <silent> <C-v> <C-r>+
nnoremap <silent> <C-z> :undo<cr>
inoremap <silent> <C-z> <esc>:undo<cr>
nnoremap <silent> <C-s> <esc>:w!<cr><esc>
xnoremap <silent> <C-s> <esc>:w!<cr><esc>
snoremap <silent> <C-s> <esc>:w!<cr><esc>
inoremap <silent> <C-s> <esc>:w!<cr><esc>

" Window splitting
nnoremap <silent> \| :split<cr>
nnoremap <silent> \ :vsplit<cr>

" Window navigation
nnoremap <silent> <C-l> :<C-u>echo<CR>
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Window resize
nnorema <silent> <C-Up> :resize +2<cr>
nnorema <silent> <C-Down> :resize -2<cr>
nnorema <silent> <C-Left> :vertical resize -2<cr>
nnorema <silent> <C-Right> :vertical resize +2<cr>

" Buffers
nnoremap <silent> <Tab> :bp<cr>
nnoremap <silent> <S-Tab> :bn<cr>
nnoremap <silent> <leader>bd :bd!<cr>
nnoremap <silent> <leader>x :x!<cr>

" Tab
nnoremap <silent> <leader><Tab><Tab> :tabnew<cr>
nnoremap <silent> <leader><Tab>l :tablast<cr>
nnoremap <silent> <leader><Tab>f :tabfirst<cr>
nnoremap <silent> <leader><Tab>n :tabnext<cr>
nnoremap <silent> <leader><Tab>p :tabprevious<cr>
nnoremap <silent> <leader><Tab>d :tabclose<cr>

" Terminal
nnoremap <silent> <leader>th :term<cr>
nnoremap <silent> <leader>tv :vert term<cr>
nnoremap <silent> <leader>tt :tab ter<cr>
nnoremap <silent> <leader>gg :tab ter ++close lazygit<cr>
tnoremap <silent> <esc><esc> <C-\><C-n>

" Netrw
nnoremap <silent> <leader>e :Lexplore<cr>
function! NetrwMapping()
    nmap <buffer> <C-l> <C-w>l
    nmap <buffer> H gh
    nmap <buffer> a %:w<CR>:buffer#<CR>
    nmap <buffer> r R
    nmap <buffer> h <CR>
    nmap <buffer> l <CR>
    nmap <buffer> ? <F1>
endfunction

" Quit
nnoremap <silent> <leader>qq :qa!<cr>
nnoremap <silent> <leader>qw :close!<cr>

" Clear search
nnoremap <silent> <esc> :noh<cr>

" GUI
if has("gui_running")
    set guioptions=""
    set guifont=Maple\ Mono\ NF\ 14
    set guicursor+=a:blinkon0

    " Misc
    vnoremap <silent> <C-S-c> "+y
    vnoremap <silent> <C-S-x> "+d
    inoremap <silent> <C-S-v> <C-r>+

    " Move lines
    " Hack: terminal emulator will send Esc when pressing Alt in vim
    " execute "set <A-j>=\ej" 
    " execute "set <A-k>=\ek"
    nnoremap <A-j> :m+<CR>
    inoremap <A-j> <Esc>:m+<CR>i
    vnoremap <A-j> :m+<CR>gv=gv
    nnoremap <A-k> :m-2<CR>
    inoremap <A-k> <Esc>:m-2<CR>i
    vnoremap <A-k> :m-2<CR>gv=gv
endif

" Jump to last edit position when opening files
silent! source $VIMRUNTIME/defaults.vim

" Check if we need to reload the file when it changed
autocmd FocusGained * checktime

" Resize splits if window is resized
autocmd VimResized * :wincmd =

" Terminal options
autocmd TerminalOpen * setlocal nonumber

" Change indent size for different filetypes
autocmd Filetype c,cpp,h,hpp,python setlocal shiftwidth=4 tabstop=4

" Commenting
function! ToggleComment(comment_char)
	if getline(".") =~ "^" . a:comment_char
		execute ".s/^" . a:comment_char . " " . "//g"
	else
		execute ".s/^/" . a:comment_char . " " . "/g"
	endif
endfunction

autocmd FileType vim nnoremap <buffer> <silent> gcc :call ToggleComment('"')<CR>
autocmd FileType javascript,typescript nnoremap <buffer> <silent> gcc :call ToggleComment("\\/\\/")<CR>
autocmd FileType php,sh,zsh,bash,markdown nnoremap <buffer> <silent> gcc :call ToggleComment("#")<CR>

" Netrw 
augroup NetrwCustomKeymaps
    autocmd!
    autocmd FileType netrw call NetrwMapping()
augroup END

augroup AutoDeleteNetrwHiddenBuffers
    autocmd!
    autocmd FileType netrw setlocal bufhidden=wipe
augroup END

" Close some filetypes with <q>
augroup FiletypeClose
    autocmd!
    autocmd FileType help nnoremap <buffer> <silent> q :q<cr>
    autocmd FileType qf nnoremap <buffer> <silent> q :q<cr>
augroup END

" Custom highlight groups
function! DrawMyColors()
    set noshowcmd
    hi! VertSplit term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
    hi! CursorLine term=NONE cterm=NONE
    hi! CursorLineNr cterm=NONE
endfunction

call DrawMyColors()
augroup MyColors
    autocmd!
    autocmd ColorScheme * call DrawMyColors()
augroup END
