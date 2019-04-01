" ------------------------------------------------------------------------------
" File:         plugin/symbols.vim
" Author:       Arthur Xavier <arthur.xavierx@gmail.com>
" Description:  Insert special characters with Vim's native completion.
" License:      GLPv3+
" ------------------------------------------------------------------------------

let g:symbols_dir = 'symbols'
let g:default_symbol_set = 'default'

command! -nargs=? -complete=custom,symbols#completeSets Symbols call symbols#load(<args>)
command! SymbolsList call symbols#list()

augroup Symbols
  autocmd!
  autocmd VimEnter * silent call symbols#load()
augroup END

function! CompleteSymbols()
  let start = symbols#complete(1, '')
  let end = col('.')

  let line = getline('.')
  let base = line[start:end]

  if line[start] == '\'
    call complete(start + 1, symbols#complete(0, base))
  endif
  return ''
endfunction
