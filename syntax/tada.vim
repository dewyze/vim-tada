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

syn match tadaDescription /^\s\{0,8}[^\-|]\+.*$/

syn region tadaTopicTitle1 matchgroup=tadaDelimiter start="^-\s\?" end=":$" oneline
syn region tadaTopicTitle2 matchgroup=tadaDelimiter start="^\s\{2}-\s\?" end=":$" oneline
syn region tadaTopicTitle3 matchgroup=tadaDelimiter start="^\s\{4}-\s\?" end=":$" oneline

syn match tadaMetadata /^\s\{2,}|.*$/

if !exists('g:tada_todo_symbols')
  if exists('g:tada_todo_symbols_set') && g:tada_todo_symbols_set == 'ascii'
    let g:tada_todo_symbols = { 'todo': ' ', 'inProgress': '-', 'done': 'x', 'blocked':'o' }
  else
    let g:tada_todo_symbols_set = 'unicode'
    let g:tada_todo_symbols = { 'todo': ' ', 'inProgress': '•', 'done': '✔︎', 'blocked':'☒' }
  endif
endif

syn region tadaTodoItem start=/^\s\+- \[.\]/ end=/$/ keepend oneline contains=tadaTodoItemBlank,tadaTodoItemInProgress,tadaTodoItemDone,tadaTodoItemBlocked

execute 'syn region tadaTodoItemBlank oneline start=/\[' . g:tada_todo_symbols['todo'] . '\].*$/ end=/$/ contained'
execute 'syn region tadaTodoItemInProgress oneline start=/\[' . g:tada_todo_symbols['inProgress'] . '\].*$/ end=/$/ contained'
execute 'syn region tadaTodoItemDone oneline start=/\[' . g:tada_todo_symbols['done'] . '\].*$/ end=/$/ contained'
execute 'syn region tadaTodoItemBlocked oneline start=/\[' . g:tada_todo_symbols['blocked'] . '\].*$/ end=/$/ contained'

hi def link tadaTopicTitle1 Define
hi def link tadaTopicTitle2 Function
hi def link tadaTopicTitle3 String
hi def link tadaTodoItemInProgress Type
hi def link tadaTodoItemDone Label
hi def link tadaTodoItemBlocked Error
hi def link tadaMetadata Identifier

let b:current_syntax = "tada"
