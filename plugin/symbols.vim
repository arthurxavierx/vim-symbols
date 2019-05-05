" ------------------------------------------------------------------------------
" File:         plugin/symbols.vim
" Author:       Arthur Xavier <arthur.xavierx@gmail.com>
" Description:  Insert special characters with Vim's native completion.
" License:      GPLv3+
" ------------------------------------------------------------------------------

" Defaults {{{

if !exists('g:symbols_dir')
  let g:symbols_dir = 'symbols'
endif

if !exists('g:symbols_default_set')
  let g:symbols_default_set = 'default'
endif

if !exists('g:symbols_character')
  let g:symbols_character = '\'
endif

if !exists('g:symbols_auto_trigger')
  let g:symbols_auto_trigger = 1
endif

if !exists('g:symbols_auto_load')
  let g:symbols_auto_load = 1
endif

if !exists('g:symbols_user_completion')
  let g:symbols_user_completion = 0
endif

" }}}

command! -nargs=? -complete=custom,symbols#completeSets Symbols call symbols#load(<args>)
command! SymbolsList call symbols#list()

let s:symbols_completing = 0

augroup Symbols
  autocmd!
  autocmd VimEnter * silent call s:Initialize()

  " Setup user completion.
  autocmd BufEnter *
        \ if g:symbols_user_completion
        \ | set completefunc=symbols#complete
        \ | endif

  " Setup automatic refresh when not using user completion.
  autocmd CompleteDone * let s:symbols_completing = 0
  autocmd TextChangedI *
        \ if !g:symbols_user_completion && s:symbols_completing
        \ | call s:SymbolsComplete()
        \ | endif
augroup END

function s:Initialize()
  if g:symbols_auto_trigger
    set completeopt+=noselect
    exe 'imap <silent> '
          \ . g:symbols_character . ' '
          \ . g:symbols_character . '<Plug>SymbolsComplete'
  endif
  if g:symbols_auto_load
    call symbols#load()
  endif
endfunction

" Attempt to trigger auto-refreshing symbol completion.
function! s:SymbolsComplete()
  let start = symbols#complete(1, '')
  let end = col('.')

  let line = getline('.')
  let base = line[start:end]

  if line[start] == g:symbols_character
    let s:symbols_completing = 1
    call complete(start + 1, symbols#complete(0, base).words)
  endif
  return ''
endfunction

inoremap <expr> <silent> <Plug>SymbolsComplete
      \ g:symbols_user_completion ? "\<C-x>\<C-u>" : "\<C-r>=<SID>SymbolsComplete()\<CR>"
