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
" TODO: make this a configurable property.
let s:special = '.-*/^'
let s:special_list = join(split(s:special, '\zs'), ',')

autocmd InsertEnter * let s:iskeyword = &iskeyword
autocmd InsertLeave * let &iskeyword = s:iskeyword
autocmd CompleteDone * let &iskeyword = s:iskeyword

" Load the symbol set identified by the name passed in as first argument. Symbol
" sets are searched in the directory named g:symbols_dir relative to the current
" runtimepath. When no argument is supplied, the g:symbols_default_set is used.
function! symbols#load(...)
  let name = get(a:, '1', g:symbols_default_set)
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

  echo 'Loaded ' . len(s:symbols) . ' symbols from symbol set "' . name . '"'
endfunction

" List all currently loaded symbols.
function! symbols#list()
  " TODO: improve formatting of symbols list.
  echo join(map(copy(s:symbols), {_, s -> s[0] . '    ' . join(s[1], ' ')}), "\n")
endfunction

" Complete function (see 'completefunc') that searches for symbols in the
" currently loaded symbol set that are identified by the `base` prefix.
function! symbols#complete(findstart, base)
  if a:findstart
    exe 'set iskeyword+=_,<,>,\(,\),[,],\{,\},\=,+,' . s:special_list
    return max([0, searchpos(g:symbols_character, 'bcnW', line('.'))[1] - 1])
  else
    if match(a:base, '^\s*' . g:symbols_character) == -1
      return []
    endif

    let base = substitute(a:base, '^\s*' . g:symbols_character, '', '')
    let r = filter(copy(s:symbols), 'v:val[0] =~ "\\C\\%(^\\|\\s\\)" . escape(base, s:special)')
    return
      \ { 'words': s:flatmap(r, {v -> map(copy(v[1]), {_,word -> {'word': word, 'menu': '    '.v[0]}})})
      \ , 'refresh': 'always'
      \ }
  endif
endfunction

" Provide completion to the :Symbols command by searching for symbol sets (files
" with extension sym or txt) under folders named g:symbols_dir in runtimepath.
function symbols#completeSets(arg, cmd, cursor)
  let files = split(globpath(&rtp, g:symbols_dir . '/' . a:arg . '*.{sym,txt}', 1), '\n')
  return join(map(files, {_, f -> fnamemodify(f, ':t:r')}), '\n')
endfunction

" Helpers {{{

" Applies `f` to all elements in `list`, concatenating all the results of this
" operation to form the result list.
function! s:flatmap(list, f) abort
  let result = []
  let r = map(copy(a:list), {_,v -> extend(result, a:f(v))})
  return len(r) > 0 ? r[-1] : r
endfunction

" }}}
