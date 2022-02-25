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
  return getline(a:lnum) =~ g:tada_pat_list_item
endfunction

function! tada#IsTodoItem(lnum)
  return getline(a:lnum) =~ g:tada_pat_todo_item
endfunction

function! tada#IsTopicTitle(lnum)
  return getline(a:lnum) =~ g:tada_pat_topic
endfunction

function! tada#IsMetadata(lnum)
  return getline(a:lnum) =~ g:tada_pat_metadata
endfunction

function! tada#TitleLevel(lnum)
  if getline(a:lnum) =~ g:tada_pat_topic
    return (indent(a:lnum) + 2) / 2
  else
    return 0
  endif
endfunction
