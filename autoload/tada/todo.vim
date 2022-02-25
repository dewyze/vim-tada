if exists('g:tada_loaded_todo_autoload')
  finish
endif
let g:tada_loaded_todo_autoload = 1

function! tada#todo#DefaultStatus()
  return b:tada_todo_statuses[0]
endfunction

function! tada#todo#DefaultSymbol()
  return b:tada_todo_symbols[b:tada_todo_statuses[0]]
endfunction

function! tada#todo#SymbolToStatus(text)
  let current = matchlist(a:text, '^\s*-\s\[\(.\)\]')[1]

  for [status, symbol] in items(b:tada_todo_symbols)
    if symbol == current
      return status
    endif
  endfor

  return tada#todo#DefaultStatus()
endfunction

function! tada#todo#ToggleTodoStatus(dir = 1)
  if !tada#IsTodoItem('.')
    return
  endif

  let status = tada#todo#SymbolToStatus(getline('.'))
  let current_symbol = b:tada_todo_symbols[status]
  let current_length = len(current_symbol)
  let status_index = index(b:tada_todo_statuses, status)
  let new_index = (status_index + a:dir) % len(b:tada_todo_statuses)
  let next_status =  b:tada_todo_statuses[new_index]
  let next_symbol = b:tada_todo_symbols[next_status]
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
