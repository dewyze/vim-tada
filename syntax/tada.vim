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

syn match tadaDescription /^\s*[^ \-|>]\+.*$/
execute 'syn match tadaComment "' . g:tada_pat_comment . '"'
execute 'syn match tadaListItem "' . g:tada_pat_list_item . '"'
execute 'syn match tadaListItem "' . g:tada_pat_list_item_empty . '"'
execute 'syn match tadaMetadata "' . g:tada_pat_metadata . '"'
execute 'syn match tadaNote "' . g:tada_pat_note . '"'

for level in [1,2,3,4,5,6]
  let indent = (level - 1) * 2
  execute 'syn region tadaTopicTitle' . level . ' matchgroup=tadaDelimiter start="^\s\{' . indent . '}-\s*" end=":$" oneline'
endfor

for [status, symbol] in items(b:tada_todo_symbols)
  let name = tada#utils#Camelize(status)

  execute 'syn match tadaTodoItem' . name . ' /^\s*-\s*\[' . symbol . '\].*$/'
endfor

execute 'syn match tadaInvalidConfig "' . g:tada_pat_invalid_config . '"'
execute 'syn match tadaBufferConfig "' . g:tada_pat_buffer_config . '"'

hi def link tadaBufferConfig tadaComment
hi def link tadaComment Comment
hi def link tadaInvalidConfig SpellBad
hi def link tadaMetadata Identifier
hi def link tadaNote SpecialComment
hi def link tadaTodoItemBlocked Error
hi def link tadaTodoItemDone Label
hi def link tadaTodoItemInProgress Type
hi def link tadaTopicTitle1 Define
hi def link tadaTopicTitle2 Function
hi def link tadaTopicTitle3 String
hi def link tadaTopicTitle4 Define
hi def link tadaTopicTitle5 Function
hi def link tadaTopicTitle6 String

hi Folded guifg=CadetBlue

let b:current_syntax = "tada"
