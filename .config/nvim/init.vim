""""""""""""""
"  vim plug  "
""""""""""""""
call plug#begin('~/.vim/pack/basic/start')
Plug 'easymotion/vim-easymotion'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tomasr/molokai'
Plug 'guns/xterm-color-table.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Exafunction/codeium.vim'
Plug 'puremourning/vimspector'
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has("nvim")
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'kdheepak/lazygit.nvim'
" 	" Plug 'voldikss/vim-floaterm'
	" Plug 'nvim-lua/plenary.nvim'
	" Plug 'nvim-telescope/telescope.nvim'
endif
Plug 'liuchengxu/vim-which-key'
call plug#end()

""""""""""""""""""
"  nvim related  "
""""""""""""""""""
if has("nvim")

	:augroup nvim
	:autocmd!
	:au VimEnter,InsertEnter,BufWinEnter,BufRead * TSBufEnable highlight
	:augroup end

	" config lazygit;
	map <leader>g :LazyGit<cr>
	let g:lazygit_floating_window_scaling_factor = 1 " scaling factor for floating window
	" set fillchars=stl:^,stlnc:=,vert:\|,fold:·,diff:-
	set fillchars=vert:\|

else
	map <leader>g :execute 'silent !lazygit'<cr>:redraw!<cr>
endif

""""""""""""""""""""""
"  builtin config  "
""""""""""""""""""""""
" set sessionoptions-=options
syntax on
" syntax sync fromstart
set background=dark

" one dark theme;
" colorscheme molokai
" colorscheme onedark
" hi String ctermfg=107
" let g:airline_theme="onedark"

" dracula theme;
colorscheme dracula
let g:airline_theme="dracula"

" catppuccin latte
" colorscheme catppuccin_latte
" let g:airline_theme="catppuccin_latte"

" hi Comment ctermfg=DarkCyan
" hi LineNr ctermfg=DarkGray}}}
filetype plugin indent on
set number
set cursorline
set cursorcolumn
set autoindent
set tabstop=4
set shiftwidth=4
set hlsearch
" set fdm=indent
set mouse=a
set showcmd
set ignorecase
set incsearch
set backspace=2
set hidden
set noswapfile
" set nobackup
" set nowritebackup
set updatetime=300
set wildmenu
set wildoptions=pum

map <leader>q :q<cr>
map <leader>w :w<cr>
map <leader>ev :vsp $MYVIMRC<cr>
map <leader>sv :source $MYVIMRC<cr>
map <leader>sa :source % <cr>
map <c-j> :bn<cr>
map <c-k> :bp<cr>
map <c-h> gT
map <c-l> gt
cmap <c-a> <home>
map Y "*y

:augroup generic
:autocmd!
:au BufWritePost $MYVIMRC source $MYVIMRC
:au VimEnter,InsertEnter,BufWinEnter,BufRead * setlocal formatoptions-=o
:augroup end


""""""""""""""""""""""
"  nerdtree config  "
""""""""""""""""""""""
map <c-n> :NERDTreeToggle<cr>
let NERDTreeIgnore= ["\.meta"]
" " let g:NERDTreeGitStatusUseNerdFonts = 1
" let g:NERDTreeGitStatusIndicatorMapCustom = { 
" 			\  "Modified" : "✹", 
" 			\  "Staged" : "✚", 
" 			\  "Untracked" : "✭", 
" 			\  "Renamed" : "➜", 
" 			\  "Unmerged" : "═", 
" 			\  "Deleted" : "✖", 
" 			\  "Dirty" : "✗", 
" 			\  "Clean" : "✔︎", 
" 			\  'Ignored' : '☒', 
" 			\  "Unknown" : "?" 
"  	\ }

""""""""""""""""""""""""
"  easymotion config  "
""""""""""""""""""""""""
" nmap F         <Plug>(easymotion-s)

""""""""""""""""""""""
"  airline config  "
""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number

""""""""""""""""""""
"  codeium config  "
""""""""""""""""""""
" let g:codeium_disable_bindings = 1
let g:codeium_no_map_tab = 1
imap <script><silent><nowait><expr> <C-h> codeium#Clear()
imap <script><silent><nowait><expr> <C-l> codeium#Accept()
imap <script><silent><nowait><expr> <C-i> codeium#Accept()
imap <script><silent><nowait><expr> <C-;> codeium#Accept()
imap <C-j>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-k>   <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x>   <Cmd>call codeium#Clear()<CR>
imap <C-y>   <Cmd>call codeium#Accept()<CR>

""""""""""""""""""""""
"  coc-nvim config  "
""""""""""""""""""""""

" Use tab to pick selection, like vscode;
inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ?
			\ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ CheckBackSpace() ? "\<TAB>" :
			\ coc#refresh()

function! CheckBackSpace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction



" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" Use tab for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<tab>'

" Use shift-tab for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<s-tab>'

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else
		execute '!' . &keywordprg . " " . expand('<cword>')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor.
augroup cocnvim
	autocmd!
	autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Show outline on window right.
map <leader>o :call CocAction("showOutline", 1)<cr>
" map <leader>o :CocOutline<cr>

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply AutoFix to problem on the current line.
nmap <space>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" Use nvim grep via rg engine.
noremap <silent><nowait> <space>rg :CocList grep<cr>

"""""""""""""""""""""" 
"  coc-snippets  "
""""""""""""""""""""""
" used for todo/fixeme signature;
let g:snips_author = "Wayne"

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

""""""""""""""""""""""
"  coc-markdown, markmap  "
""""""""""""""""""""""
map <leader>md :CocCommand markdown-preview-enhanced.openPreview<cr>
nmap <Leader>mm :CocCommand markmap.watch<cr>

""""""""""""""""""""""
"  coc-prettier  "
""""""""""""""""""""""
" command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
command! -nargs=0 Prettier :CocCommand prettier.formatFile

""""""""""""""""""""
"  coc-translator  "
""""""""""""""""""""
" popup
nmap <Leader>d <Plug>(coc-translator-p)
vmap <Leader>d <Plug>(coc-translator-pv)
" echo
nmap <Leader>e <Plug>(coc-translator-e)
vmap <Leader>e <Plug>(coc-translator-ev)

""""""""""""""""""""""
"  fzf.vim  config  "
""""""""""""""""""""""
" let g:fzf_preview_window = ['right:50%', 'ctrl-/']
" let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" let g:fzf_layout = { 'down': '40%' }
" let g:fzf_preview_window = ['up:40%', 'ctrl-/']
" map <c-p> :GFiles<cr>
" map <expr> <c-p> pumvisible() ? "\^[" : ":GFiles<cr>" 
map <c-p> :GFiles<cr>
map <nowait><leader>rg :Rg<cr>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

""""""""""""""""""""""
"  Learn Vim Script  "
"""""""""""""""""""""

""""""""""""""""""""""""""
"  vimspector for debug  "
""""""""""""""""""""""""""
" let g:vimspector_enable_mappings = 'HUMAN'
" let g:vimspector_base_dir='/Users/Forest/.vim/pack/basic/start/vimspector'
" let g:vimspector_sidebar_width = 25
" let g:vimspector_bottombar_height = 10

" nnoremenu WinBar.■\ Stop :call vimspector#Stop( { 'interactive': v:false } )<CR>
" nnoremenu WinBar.▶\ Cont :call vimspector#Continue()<CR>
" nnoremenu WinBar.▷\ Pause :call vimspector#Pause()<CR>
" nnoremenu WinBar.↷\ Next :call vimspector#StepOver()<CR>
" nnoremenu WinBar.→\ Step :call vimspector#StepInto()<CR>
" nnoremenu WinBar.←\ Out :call vimspector#StepOut()<CR>
" nnoremenu WinBar.⟲: :call vimspector#Restart()<CR>
" nnoremenu WinBar.✕ :call vimspector#Reset( { 'interactive': v:false } )<CR>


" deug shortcuts with proper abbr;
" launch, toggle, breakpoint, continue, ., pause, 
" j-next, into, out, restart, quit.
nnoremap <space>dl :call vimspector#Launch()<CR>
nnoremap <space>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <space>dT :call vimspector#ClearBreakpoints()<CR>
nnoremap <space>db <Plug>VimspectorBreakpoints
" nnoremap <space>dc <Plug>VimspectorContinue	
nnoremap <space>dc :call vimspector#Continue()<CR>
nnoremap <space>d. :call vimspector#RunToCursor()<CR>
nnoremap <space>dp <Plug>VimspectorPause
nnoremap <space>dj :call vimspector#StepOver()<CR>
" <Plug>VimspectorStepOver
" nnoremap <space>di <Plug>VimspectorStepIn
nnoremap <space>di :call vimspector#StepInto()<CR>
nnoremap <space>do :call vimspector#StepOut()<CR>
" <Plug>VimspectorStepOut
" nnoremap <space>dr <Plug>VimspectorRestart
nnoremap <space>dr :call vimspector#Restart()<CR>
nnoremap <space>dq :VimspectorReset<CR>
nnoremap <space>de <Plug>VimspectorBalloonEval
" nnoremap <space>ds <Plug>VimspectorStop
" nnoremap <space>ds :call vimspector#ToggleBreakpoint( { trigger expr, hit count expr } )<CR>

""""""""""""""
"  fugitive  "
""""""""""""""
map <space>g :Git<cr>

"""""""""""""""
"  which key  "
"""""""""""""""
" set timeoutlen=200
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
nnoremap <silent> <Space> :<c-u>WhichKey '<Space>'<CR>

"""""""""""""
"  app dev  "
"""""""""""""
map <space><space> :execute 'silent !open /Applications/Visual\ Studio\ Code.app'<cr>:redraw!<cr>
map <space>1 :execute 'silent !open /Applications/Google\ Chrome.app'<cr>:redraw!<cr>
map <space>2 :execute 'silent !open https://www.behaviortrees.com'<cr>:redraw!<cr>
map <space>3 :silent execute '!open %'<cr>:redraw!<cr>
map <space>5 :execute 'silent !open /Applications/Visual\ Studio\ Code.app'<cr>:redraw!<cr>
map <space>7 :execute 'silent !open /Users/Forest/Library/Application\ Support/Steam/steamapps/common/Aseprite/Aseprite.app'<cr>:redraw!<cr>
map <space>8 :execute 'silent !open /Applications/Cocos/Creator/2.4.12/CocosCreator.app'<cr>:redraw!<cr>
map <space>9 :execute 'silent !open http://localhost:7456/'<cr>:redraw!<cr>
map <leader>rr :execute 'silent !ranger'<cr>:redraw!<cr>

" nnoremenu WinBar.← <c-o>
" nnoremenu WinBar.→ <c-i>
augroup devtool
	autocmd!
	" au filetype python :echo "python file"
	" menu WinBar.Run :echo "hi"<cr>
	" au User *.py :!python %
	" menu WinBar.Run :doautocmd User<cr>
	" menu WinBar.Run :!python %<cr>
	nnoremenu WinBar.▷\ chrome :execute 'silent !open /Applications/Google\ Chrome.app'<cr>:redraw!<cr>
	nnoremenu WinBar.▶\ localhost :execute 'silent !open http://localhost:7456/'<cr>:redraw!<cr>

	" menu WinBar.<-- :bp<cr>
	" menu WinBar.--> :bn<cr>
augroup end
