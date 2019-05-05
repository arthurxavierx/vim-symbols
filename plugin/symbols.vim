" ------------------------------------------------------------------------------
" File:         plugin/symbols.vim
" Author:       Arthur Xavier <arthur.xavierx@gmail.com>
" Description:  Insert special characters with Vim's native completion.
" License:      GPLv3+
" ------------------------------------------------------------------------------

" Defaults {{{

" TODO: write documentation.
if !exists('g:symbols_dir')
  let g:symbols_dir = 'symbols'
endif

" TODO: write documentation.
if !exists('g:symbols_default_set')
  let g:symbols_default_set = 'default'
endif

" TODO: write documentation.
if !exists('g:symbols_character')
  let g:symbols_character = '\'
endif

" TODO: write documentation.
if !exists('g:symbols_user_completion')
  let g:symbols_user_completion = 1
endif

" TODO: write documentation.
if !exists('g:symbols_auto_trigger')
  let g:symbols_auto_trigger = 1
endif

" }}}

command! -nargs=? -complete=custom,symbols#completeSets Symbols call symbols#load(<args>)
command! SymbolsList call symbols#list()

augroup Symbols
  autocmd!
  autocmd VimEnter * silent call s:Initialize()
  autocmd BufEnter *
        \ if g:symbols_user_completion
        \ | set completefunc=symbols#complete
        \ | endif
augroup END

function s:Initialize()
  if g:symbols_auto_trigger
    exe 'inoremap <expr> '
          \ . g:symbols_character
          \ . ' g:symbols_user_completion ? "\\\<C-x>\<C-u>" : "\\\<C-r>=CompleteSymbols()<CR>"'
  endif
  call symbols#load()
endfunction

" TODO: write documentation.
function! CompleteSymbols()
  let start = symbols#complete(1, '')
  let end = col('.')

  let line = getline('.')
  let base = line[start:end]

  if line[start] == '\'
    echo start . ' ' . base
    call complete(start + 1, symbols#complete(0, base).words)
  endif
  return ''
endfunction
