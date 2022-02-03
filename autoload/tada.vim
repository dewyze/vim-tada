if exists('g:tada_loaded_autoload')
  finish
endif
let g:tada_loaded_autoload = 1

function! tada#SyntaxGroupOfLine(lnum)
  let stack = synstack(a:lnum, 1)

  if len(stack) > 0
    return synIDattr(stack[0], 'name')
  endif
  return ''
endfunction

function! tada#IsTodoItem(lnum)
  return tada#SyntaxGroupOfLine(a:lnum) =~ '^tadaTodoItem'
endfunction

function! tada#NextTodoStatus()
  call tada#todo#ToggleTodoStatus(1)
endfunction

function! tada#PreviousTodoStatus()
  call tada#todo#ToggleTodoStatus(-1)
endfunction
