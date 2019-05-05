# symbols.vim

Insert special characters with Vim's native completion.

## Table of contents

1. [Installation](#installation)
1. [Usage](#usage)
1. [Options](#options)

## Installation

`vim-symbols` may be installed by any of your favourite plugin managers. Be it Pathogen, Vundle or Plug, use whichever you prefer.

For example, when using with [Plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'arthurxavierx/vim-symbols'
```

## Usage

`vim-symbols` allows for easily inserting special symbols or words through Vim's
native completion mechanism. These special symbols or words can be identified
by multiple other words in a dictionary-like way. Indeed vim-symbols reads
symbol files (called symbol sets) to spin up its symbol completion mechanism.

To use this plugin, simply install it using your favorite plugin manager and,
in insert mode, type \ to open the symbols popup.

For customization, please see the [Options](#options) section below.

## Options

 Name | Default | Description
------|---------|-------------
`g:symbols_dir` | `'symbols'` | Name of the folder (relative to `runtimepath`) in which symbol sets are to be found.
`g:symbols_default_set` | `'default'` | Name of the symbol set loaded when initializing Vim if `g:symbols_auto_load` is `1`
`g:symbols_character` | `'\'` | Prefix character used for identifying a symbol. In order to trigger symbol completion in a word, it must begin with this character. Furthermore, symbol completion is automatically triggered when typing this character in insert mode with `g:symbols_auto_trigger` set to `1`.
`g:symbols_auto_trigger` | `1` | When set to 1, inserting the character defined by `g:symbols_character` automatically triggers symbol completion.
`g:symbols_auto_load` | `1` | When set to 1, the `g:symbols_default_set` is loaded when initializing Vim.
`g:symbols_user_completion` | `0` | When set to 1, `'completefunc'` is used for completing symbols.
