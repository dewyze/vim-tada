if exists('b:did_ftplugin') | finish | endif


if !exists('g:tada_todo_switch_status_mapping')
  let g:tada_todo_switch_status_mapping = '<Space>'
endif
if !exists('g:tada_todo_switch_status_reverse_mapping')
  let g:tada_todo_switch_status_reverse_mapping = '<C-Space>'
endif

function! s:DoesHandleAutoline()
  let group = tada#SyntaxGroupOfLine('.')

  return tada#IsTodoItem('.') || tada#IsMetadata('.')
endfunction

execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_mapping . ' :call tada#NextTodoStatus()<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_reverse_mapping . ' :call tada#PreviousTodoStatus()<CR>'
inoremap <silent> <buffer> <script> <expr> <CR> <SID>DoesHandleAutoline() ? '<C-O>:call tada#autoline#Down()<CR>' : '<CR>'
nnoremap <silent> <buffer> <script> <expr> o <SID>DoesHandleAutoline() ? ':call tada#autoline#Down()<CR>a' : 'o'
nnoremap <silent> <buffer> <script> <expr> O <SID>DoesHandleAutoline() ? ':call tada#autoline#Up()<CR>a' : 'O'

setlocal ts=2 sw=2 expandtab smarttab
setlocal autoindent
let b:did_ftplugin = 1
