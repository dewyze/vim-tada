if exists('b:did_ftplugin') | finish | endif


if !exists('g:tada_todo_switch_status_mapping')
  let g:tada_todo_switch_status_mapping = '<Space>'
endif
if !exists('g:tada_todo_switch_status_reverse_mapping')
  let g:tada_todo_switch_status_reverse_mapping = '<C-Space>'
endif

execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_mapping . ' :call tada#NextTodoStatus()<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_reverse_mapping . ' :call tada#PreviousTodoStatus()<CR>'

let b:did_ftplugin = 1
