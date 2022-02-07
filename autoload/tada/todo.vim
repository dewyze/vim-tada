if exists('g:tada_loaded_todo_autoload')
  finish
endif
let g:tada_loaded_todo_autoload = 1

let s:todo_statuses = ['tadaTodoItemBlank', 'tadaTodoItemInProgress', 'tadaTodoItemDone', 'tadaTodoItemBlocked']

function! tada#todo#TodoSyntaxToSymbol(status)
  let symbol_keys = {
        \ 'tadaTodoItemBlank': 'todo',
        \ 'tadaTodoItemInProgress': 'in_progress',
        \ 'tadaTodoItemDone': 'done',
        \ 'tadaTodoItemBlocked': 'blocked',
        \ }

  return g:tada_todo_symbols[symbol_keys[a:status]]
endfunction

function! tada#todo#GetNextTodoStatus(group, dir = 1)
  let status_index = index(s:todo_statuses, a:group)

  let new_index = (status_index + a:dir) % 4

  return s:todo_statuses[new_index]
endfunction

function! tada#todo#ToggleTodoStatus(dir = 1)
  if !tada#IsTodoItem('.')
    return
  endif

  let group = tada#SyntaxGroupOfLine(line('.'))
  let current_symbol = tada#todo#TodoSyntaxToSymbol(group)
  let current_length = len(current_symbol)
  let status_index = index(s:todo_statuses, group)
  let new_index = (status_index + a:dir) % 4
  let next_status =  s:todo_statuses[new_index]
  let next_symbol = tada#todo#TodoSyntaxToSymbol(next_status)
  let next_length = len(next_symbol)
  let offset = current_length - next_length
  let colpos = col('.')

  call cursor(line('.'), 1)
  let [symline, symcol] = searchpos('\[' . current_symbol . '\]', 'n', line('.'))
  call setline('.', substitute(getline('.'), '^\(\s*-\s\?\)\[.\]', '\1[' . next_symbol . ']', ''))

  let symcol = symcol + 1

  if colpos <= symcol
    call cursor(line('.'), colpos)
  elseif colpos > symcol
    call cursor(line('.'), colpos - offset)
  endif
endfunction
