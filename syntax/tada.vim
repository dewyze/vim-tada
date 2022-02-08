" Vim syntax file
" Language:   Tada
" Maintainer: John DeWyze <john@dewyze.dev>
" Filenames:  *.tada

if exists("b:current_syntax")
  finish
endif

syn spell toplevel
syn sync fromstart
syn case ignore


syn match tadaDescription /^\s*[^ \-|]\+.*$/
syn match tadaMetadata /^\s\{2,}|.*$/
syn match tadaListItem /^\s*-\s*$/
syn region tadaListItem start=/^\s*-\s*[^ []/ end=/[^:]$/ oneline

syn region tadaTopicTitle1 matchgroup=tadaDelimiter start="^-\s\?" end=":$" oneline
syn region tadaTopicTitle2 matchgroup=tadaDelimiter start="^\s\{2}-\s\?" end=":$" oneline
syn region tadaTopicTitle3 matchgroup=tadaDelimiter start="^\s\{4}-\s\?" end=":$" oneline

if !exists('g:tada_todo_symbols')
  if exists('g:tada_todo_symbols_set') && g:tada_todo_symbols_set == 'ascii'
    let g:tada_todo_symbols = { 'blank': ' ', 'in_progress': '-', 'done': 'x', 'blocked':'o' }
  else
    let g:tada_todo_symbols_set = 'unicode'
    let g:tada_todo_symbols = { 'blank': ' ', 'in_progress': '•', 'done': '✔︎', 'blocked':'☒' }
  endif
endif

execute 'syn match tadaTodoItemBlank /^\s*-\s*\[' . g:tada_todo_symbols['blank'] . '\].*$/'
execute 'syn match tadaTodoItemInProgress /^\s*-\s*\[' . g:tada_todo_symbols['in_progress'] . '\].*$/'
execute 'syn match tadaTodoItemDone /^\s*-\s*\[' . g:tada_todo_symbols['done'] . '\].*$/'
execute 'syn match tadaTodoItemBlocked /^\s*-\s*\[' . g:tada_todo_symbols['blocked'] . '\].*$/'

syn match tadaInvalidConfig /^@config\..*$/
syn match tadaBufferConfig /^@config\.[^ ]\+\s\?=\s\?.\+$/

hi def link tadaTopicTitle1 Define
hi def link tadaTopicTitle2 Function
hi def link tadaTopicTitle3 String
hi def link tadaTodoItemInProgress Type
hi def link tadaTodoItemDone Label
hi def link tadaTodoItemBlocked Error
hi def link tadaInvalidConfig SpellBad
hi def link tadaBufferConfig Comment
hi def link tadaMetadata Identifier

hi Folded guifg=CadetBlue

let b:current_syntax = "tada"
