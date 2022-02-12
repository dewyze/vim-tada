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
syn match tadaComment /^\s*#.*$/
syn match tadaListItem /^\s*-\s*$/
syn region tadaListItem start=/^\s*-\s*[^ []/ end=/\(:\)\@<!$/ oneline

syn region tadaTopicTitle1 matchgroup=tadaDelimiter start="^-\s\?" end=":$" oneline
syn region tadaTopicTitle2 matchgroup=tadaDelimiter start="^\s\{2}-\s\?" end=":$" oneline
syn region tadaTopicTitle3 matchgroup=tadaDelimiter start="^\s\{4}-\s\?" end=":$" oneline
syn region tadaTopicTitle4 matchgroup=tadaDelimiter start="^\s\{6}-\s\?" end=":$" oneline
syn region tadaTopicTitle5 matchgroup=tadaDelimiter start="^\s\{8}-\s\?" end=":$" oneline
syn region tadaTopicTitle6 matchgroup=tadaDelimiter start="^\s\{10}-\s\?" end=":$" oneline

for [status, symbol] in items(b:tada_todo_symbols)
  let name = tada#utils#Camelize(status)

  execute 'syn match tadaTodoItem' . name . ' /^\s*-\s*\[' . symbol . '\].*$/'
endfor

syn match tadaInvalidConfig /^@config\..*$/
syn match tadaBufferConfig /^@config\.[^ ]\+\s\?=\s\?.\+$/

hi def link tadaTopicTitle1 Define
hi def link tadaTopicTitle2 Function
hi def link tadaTopicTitle3 String
hi def link tadaTopicTitle4 Define
hi def link tadaTopicTitle5 Function
hi def link tadaTopicTitle6 String
hi def link tadaTodoItemInProgress Type
hi def link tadaTodoItemDone Label
hi def link tadaTodoItemBlocked Error
hi def link tadaInvalidConfig SpellBad
hi def link tadaBufferConfig Comment
hi def link tadaComment Comment
hi def link tadaMetadata Identifier

hi Folded guifg=CadetBlue

let b:current_syntax = "tada"
