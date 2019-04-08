" ------------------------------------------------------------------------------
" File:         syntax/symbols.vim
" Author:       Arthur Xavier <arthur.xavierx@gmail.com>
" Description:  Insert special characters with Vim's native completion.
" License:      GPLv3+
" ------------------------------------------------------------------------------

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "symbols"

syntax match symbolsNames /[^:]\+:/me=e-1
syntax match symbolsSymbol /:.*$/ms=s+1
syntax match symbolsComment /^\s*".*/

hi! link symbolsComment Comment
hi! link symbolsNames String
hi! link symbolsSymbol Normal
