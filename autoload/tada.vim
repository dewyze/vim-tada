if exists('g:tada_loaded_autoload')
  finish
endif
let g:tada_loaded_autoload = 1

let g:tada_fold_level = 3

function! tada#SyntaxGroupOfLine(lnum)
  let stack = synstack(a:lnum, 1)

  if len(stack) > 0
    return synIDattr(stack[0], 'name')
  endif
  return ''
endfunction

function! tada#IsListItem(lnum)
  return tada#SyntaxGroupOfLine(a:lnum) == 'tadaListItem'
endfunction

function! tada#IsTodoItem(lnum)
  return tada#SyntaxGroupOfLine(a:lnum) =~ '^tadaTodoItem'
endfunction

function! tada#IsTopicTitle(lnum)
  return tada#SyntaxGroupOfLine(a:lnum) =~ '^tadaTopicTitle'
endfunction

function! tada#IsMetadata(lnum)
  return tada#SyntaxGroupOfLine(a:lnum) == 'tadaMetadata'
endfunction

function! tada#TitleLevel(lnum)
  let matches = matchlist(tada#SyntaxGroupOfLine(a:lnum), '^tadaTopicTitle\(\d\)')

  if len(matches) > 0
    return matches[1]
  else
    return 0
  endif
endfunction

function! tada#NextTodoStatus()
  call tada#todo#ToggleTodoStatus(1)
endfunction

function! tada#PreviousTodoStatus()
  call tada#todo#ToggleTodoStatus(-1)
endfunction
