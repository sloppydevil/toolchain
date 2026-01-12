-- Converted from .vimrc to Neovim Lua config

-- Plugin setup with vim-plug (kept as is)
vim.cmd([[
call plug#begin('~/.vim/pack/start')
Plug 'easymotion/vim-easymotion'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tomasr/molokai'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Exafunction/codeium.vim'
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/vim-which-key'
Plug 'habamax/vim-godot'
if has("nvim")
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'kdheepak/lazygit.nvim'
  Plug 'NickvanDyke/opencode.nvim'
endif
call plug#end()
]])

-- Neovim related config
vim.opt.fillchars = { vert = '|' }
vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>')
vim.g.lazygit_floating_window_scaling_factor = 1

-- Builtin config
vim.cmd('syntax on')
vim.cmd('colorscheme dracula')
vim.opt.termguicolors = true
vim.cmd('filetype plugin indent on')
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.hlsearch = true
vim.opt.mouse = 'a'
vim.opt.showcmd = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.backspace = '2'
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.wildmenu = true
vim.opt.wildoptions = 'pum'

vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<leader>ev', '<cmd>vsp $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>sv', '<cmd>source $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>sa', '<cmd>source %<cr>')
vim.keymap.set('n', '<c-j>', '<cmd>bn<cr>')
vim.keymap.set('n', '<c-k>', '<cmd>bp<cr>')
vim.keymap.set('n', '<c-h>', 'gT')
vim.keymap.set('n', '<c-l>', 'gt')
vim.keymap.set('c', '<c-a>', '<home>')
vim.keymap.set('n', 'Y', '"*y')

-- Autocmds
local generic_augroup = vim.api.nvim_create_augroup('generic', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = vim.fn.expand('$MYVIMRC'),
  command = 'source ' .. vim.fn.expand('$MYVIMRC'),
  group = generic_augroup,
})
vim.api.nvim_create_autocmd({ 'VimEnter', 'InsertEnter', 'BufWinEnter', 'BufRead' }, {
  pattern = '*',
  command = 'setlocal formatoptions-=o',
  group = generic_augroup,
})

-- Airline config
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
vim.g['airline#extensions#tabline#tab_nr_type'] = 1
vim.g['airline#extensions#disable_rtp_load'] = 1

-- NERDTree config
vim.keymap.set('n', '<c-n>', '<cmd>NERDTreeToggle<cr>')
vim.g.NERDTreeIgnore = { '\\.meta' }

-- Codeium config
vim.g.codeium_no_map_tab = 1
vim.keymap.set('i', '<C-h>', function() return vim.fn['codeium#Accept']() end, { expr = true, script = true, silent = true, nowait = true })
vim.keymap.set('i', '<C-i>', function() return vim.fn['codeium#Accept']() end, { expr = true, script = true, silent = true, nowait = true })
vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, script = true, silent = true, nowait = true })
vim.keymap.set('i', '<C-m>', function() return vim.fn['codeium#Accept']() end, { expr = true, script = true, silent = true, nowait = true })
vim.keymap.set('i', '<C-j>', '<Cmd>call codeium#CycleCompletions(1)<CR>')
vim.keymap.set('i', '<C-k>', '<Cmd>call codeium#CycleCompletions(-1)<CR>')

-- Coc config
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.signcolumn = 'yes'

-- Completion mappings (simplified)
vim.keymap.set('i', '<TAB>', function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#pum#confirm']()
  elseif vim.fn['coc#expandableOrJumpable']() == 1 then
    return vim.fn['coc#rpc#request']('doKeymap', { 'snippets-expand-jump', '' })
  elseif CheckBackspace() then
    return '<TAB>'
  else
    vim.fn['coc#refresh']()
    return ''
  end
end, { expr = true })

vim.keymap.set('i', '<CR>', function()
  if vim.fn['coc#pum#visible']() == 1 then
    return vim.fn['coc#pum#confirm']()
  else
    return '<C-g>u<CR><c-r>=coc#on_enter()<CR>'
  end
end, { expr = true, silent = true })

function CheckBackspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

vim.keymap.set('i', '<c-space>', function() return vim.fn['coc#refresh']() end, { expr = true, silent = true })

-- Navigation
vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true, nowait = true })
vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true, nowait = true })
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true, nowait = true })
vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true, nowait = true })
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true, nowait = true })
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true, nowait = true })

vim.keymap.set('n', 'K', function() ShowDocumentation() end, { silent = true })

function ShowDocumentation()
  if vim.fn.CocAction('hasProvider', 'hover') == 1 then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_feedkeys('K', 'in', false)
  end
end

vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  command = "silent call CocActionAsync('highlight')",
})

-- Other coc mappings
vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)')
vim.keymap.set('x', '<leader>f', '<Plug>(coc-format-selected)')
vim.keymap.set('n', '<leader>f', '<Plug>(coc-format-selected)')

-- Autocmd for formatting
local mygroup = vim.api.nvim_create_augroup('mygroup', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typescript,json',
  command = 'setl formatexpr=CocAction(\'formatSelected\')',
  group = mygroup,
})

-- Code actions
vim.keymap.set('x', '<leader>a', '<Plug>(coc-codeaction-selected)')
vim.keymap.set('n', '<leader>a', '<Plug>(coc-codeaction-selected)')
vim.keymap.set('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)')
vim.keymap.set('n', '<leader>as', '<Plug>(coc-codeaction-source)')
vim.keymap.set('n', '<space>qf', '<Plug>(coc-fix-current)')

vim.keymap.set('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', { silent = true })
vim.keymap.set('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })
vim.keymap.set('n', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', { silent = true })

vim.keymap.set('n', '<leader>cl', '<Plug>(coc-codelens-action)')

-- Text objects
vim.keymap.set('x', 'if', '<Plug>(coc-funcobj-i)')
vim.keymap.set('o', 'if', '<Plug>(coc-funcobj-i)')
vim.keymap.set('x', 'af', '<Plug>(coc-funcobj-a)')
vim.keymap.set('o', 'af', '<Plug>(coc-funcobj-a)')
vim.keymap.set('x', 'ic', '<Plug>(coc-classobj-i)')
vim.keymap.set('o', 'ic', '<Plug>(coc-classobj-i)')
vim.keymap.set('x', 'ac', '<Plug>(coc-classobj-a)')
vim.keymap.set('o', 'ac', '<Plug>(coc-classobj-a)')

-- Scroll
if vim.fn.has('nvim-0.4.0') == 1 or vim.fn.has('patch-8.2.0750') == 1 then
  vim.keymap.set('n', '<C-f>', function()
    if vim.fn['coc#float#has_scroll']() == 1 then
      return vim.fn['coc#float#scroll'](1)
    else
      return '<C-f>'
    end
  end, { expr = true, silent = true, nowait = true })
  vim.keymap.set('n', '<C-b>', function()
    if vim.fn['coc#float#has_scroll']() == 1 then
      return vim.fn['coc#float#scroll'](0)
    else
      return '<C-b>'
    end
  end, { expr = true, silent = true, nowait = true })
  -- Similar for i and x modes
end

vim.keymap.set('n', '<C-s>', '<Plug>(coc-range-select)', { silent = true })
vim.keymap.set('x', '<C-s>', '<Plug>(coc-range-select)', { silent = true })

vim.api.nvim_create_user_command('Format', 'call CocActionAsync(\'format\')', { nargs = 0 })
vim.api.nvim_create_user_command('Fold', 'call CocAction(\'fold\', <f-args>)', { nargs = '?' })
vim.api.nvim_create_user_command('OR', 'call CocActionAsync(\'runCommand\', \'editor.action.organizeImport\')', { nargs = 0 })

-- CocList
vim.keymap.set('n', '<space>a', '<cmd>CocList diagnostics<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>e', '<cmd>CocList extensions<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>c', '<cmd>CocList commands<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>o', '<cmd>CocList outline<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<leader>o', '<cmd>CocOutline<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>s', '<cmd>CocList -I symbols<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>j', '<cmd>CocNext<CR>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>k', '<cmd>CocPrev<CR>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>p', '<cmd>CocListResume<CR>', { silent = true, nowait = true })

-- Snippets
vim.g.snips_author = 'Wayne'
vim.keymap.set('x', '<leader>x', '<Plug>(coc-convert-snippet)')

-- Markdown
vim.keymap.set('n', '<leader>md', '<cmd>CocCommand markdown-preview-enhanced.openPreview<cr>')
vim.keymap.set('n', '<leader>mm', '<cmd>CocCommand markmap.watch<cr>')

-- Translator
vim.keymap.set('n', '<Leader>d', '<Plug>(coc-translator-p)')
vim.keymap.set('v', '<Leader>d', '<Plug>(coc-translator-pv)')
vim.keymap.set('n', '<Leader>e', '<Plug>(coc-translator-e)')
vim.keymap.set('v', '<Leader>e', '<Plug>(coc-translator-ev)')

-- FZF
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
vim.keymap.set('n', '<c-p>', '<cmd>GFiles<cr>')
vim.keymap.set('n', '<leader>f', '<cmd>Rg<cr>', { nowait = true })
vim.keymap.set('i', '<c-x><c-k>', '<plug>(fzf-complete-word)')
vim.keymap.set('i', '<c-x><c-f>', '<plug>(fzf-complete-path)')
vim.keymap.set('i', '<c-x><c-l>', '<plug>(fzf-complete-line)')

-- Which Key
vim.keymap.set('n', '<leader>', '<cmd>WhichKey \'<leader>\'<CR>', { silent = true })
vim.keymap.set('n', '<Space>', '<cmd>WhichKey \'<Space>\'<CR>', { silent = true })

-- Godot
vim.g.godot_executable = '/Applications/Godot.app/Contents/MacOS/Godot'

-- App shortcuts
vim.keymap.set('n', '<space><space>', '<cmd>silent !open /Applications/Visual\\ Studio\\ Code.app<cr><cmd>redraw!<cr>')
vim.keymap.set('n', '<space>1', '<cmd>silent !open /Applications/Google\\ Chrome.app<cr><cmd>redraw!<cr>')
vim.keymap.set('n', '<space>5', '<cmd>silent !open /Applications/Visual\\ Studio\\ Code.app<cr><cmd>redraw!<cr>')
vim.keymap.set('n', '<space>7', '<cmd>silent !open /Users/Wayne/Library/Application\\ Support/Steam/steamapps/common/Aseprite/Aseprite.app<cr><cmd>redraw!<cr>')

-- Opencode config (added)
vim.g.opencode_opts = {}
vim.opt.autoread = true
-- vim.keymap.set({ 'n', 'x' }, '<C-a>', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
vim.keymap.set({ 'n', 'x' }, '<C-i>', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
-- vim.keymap.set({ 'n', 'x' }, '<C-x>', function() require('opencode').select() end, { desc = 'Execute opencode action…' })
vim.keymap.set({ 'n', 'x' }, '<C-h>', function() require('opencode').select() end, { desc = 'Execute opencode action…' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
vim.keymap.set({ 'n', 'x' }, 'go', function() return require('opencode').operator('@this ') end, { expr = true, desc = 'Add range to opencode' })
vim.keymap.set('n', 'goo', function() return require('opencode').operator('@this ') .. '_' end, { expr = true, desc = 'Add line to opencode' })
vim.keymap.set('n', '<S-C-u>', function() require('opencode').command('session.half.page.up') end, { desc = 'opencode half page up' })
vim.keymap.set('n', '<S-C-d>', function() require('opencode').command('session.half.page.down') end, { desc = 'opencode half page down' })
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
