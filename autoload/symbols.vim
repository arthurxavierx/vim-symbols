" ------------------------------------------------------------------------------
" File:         autoload/symbols.vim
" Author:       Arthur Xavier <arthur.xavierx@gmail.com>
" Description:  Insert special characters with Vim's native completion.
" License:      GPLv3+
" ------------------------------------------------------------------------------

let s:symbols = []
let s:iskeyword = &iskeyword

" Special characters temporarily added to `iskeyword` while completing symbols.
" This allows for using these characters in symbol names.
let s:special = '.-*/^'
let s:special_list = join(split(s:special, '\zs'), ',')

autocmd InsertEnter * let s:iskeyword = &iskeyword
autocmd InsertLeave * let &iskeyword = s:iskeyword
autocmd CompleteDone * let &iskeyword = s:iskeyword

function! symbols#load(...)
  let name = get(a:, '1', g:default_symbol_set)
  let s:symbols = []

  let s:iskeyword = &iskeyword
  exe 'set iskeyword+=_,<,>,\(,\),[,],\{,\},\=,+,' . s:special_list

  let filenames = split(globpath(&rtp, g:symbols_dir . '/' . name . '.{sym,txt}', 1), '\n')
  if len(filenames) <= 0
    throw "No symbol set found for '" . name . "'"
  elseif len(filenames) > 1
    throw "More than one symbol set found for '" . name . "'"
  endif

  call substitute(
    \ join(readfile(filenames[0]), "\n"),
    \ '\v%(^|\n+)([^" ]%(\k|\s)*):\s*([^\n]+)',
    \ '\=add(s:symbols, [submatch(1), split(submatch(2), "\\s")])',
    \ 'gn'
    \ )

  let &iskeyword = s:iskeyword

  echo 'Loaded ' . len(s:symbols) . ' symbols'
endfunction

function! symbols#list()
  echo join(map(copy(s:symbols), {_, s -> '{ ' . s[0] . ' : ' . join(s[1], ' ') . ' }'}), ', ')
endfunction

function! symbols#complete(findstart, base)
  if a:findstart
    exe 'set iskeyword+=_,<,>,\(,\),[,],\{,\},\=,+,' . s:special_list
    return max([0, searchpos('\\', 'bcnW', line('.'))[1] - 1])
  else
    if match(a:base, '^\s*\\') == -1
      return []
    endif

    let base = substitute(a:base, '^\s*\\', '', '')
    let r = filter(copy(s:symbols), 'v:val[0] =~ "\\C\\%(^\\|\\s\\)" . escape(base, s:special)')
    return
      \ { 'words': s:flatmap(r, {v -> map(copy(v[1]), {_,word -> {'word': word, 'menu': '    '.v[0]}})})
      \ , 'refresh': 'always'
      \ }
      \
  endif
endfunction

function! s:flatmap(list, f) abort
  let result = []
  let r = map(copy(a:list), {_,v -> extend(result, a:f(v))})
  return len(r) > 0 ? r[-1] : r
endfunction
