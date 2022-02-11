if exists('g:tada_loaded_box_autoload')
  finish
endif
let g:tada_loaded_box_autoload = 1

function! tada#box#Toggle()
  let group = tada#SyntaxGroupOfLine('.')
  let text = getline('.')
  let s:save_col = col('.')
  let s:boxlen = len('[' . tada#todo#DefaultSymbol() . '] ')
  let s:blank_box = '[' . tada#todo#DefaultSymbol() . '] '
  let s:prev_line_num = line('.') - 1

  if text =~ '^\s*$' && tada#SyntaxGroupOfLine(s:prev_line_num) =~ '^tadaTodoItem'
    call s:BoxForBlankLinkBelowTodo()
  elseif text =~ '^\s*$'
    call s:BoxForBlankLinkNotBelowTodo()
  elseif text =~ '^\(\s*-\)\@!.\+$'
    call s:BoxForDescriptionLine()
  elseif text =~ '^\s*-\s*$'
    call s:BoxForEmptyTodoItem()
  elseif group == 'tadaListItem' || group =~ '^tadaTopicTitle'
    call s:BoxForListItemOrTopic()
  elseif group =~ '^tadaTodoItem'
    call s:RemoveBoxForTodoItem()
  endif
endfunction

function! s:BoxForBlankLinkBelowTodo()
  let spaces = repeat(' ', max([indent(s:prev_line_num), 0]))
  call setline('.', spaces . '- ' . s:blank_box)
  call cursor(line('.'), s:NewColPos(0))
endfunction

function! s:BoxForBlankLinkNotBelowTodo()
  let spaces = indent('.')
  call setline('.', repeat(' ', spaces) . '- ' . s:blank_box)
  normal! $
endfunction

function! s:BoxForDescriptionLine()
  let spaces = repeat(' ', max([indent('.') - 6, 0]))
  call setline('.', substitute(getline('.'), '^\(\s*\)\(\S.*\)$', spaces . '- ' . s:blank_box . '\2', ''))
  call cursor(line('.'), s:NewColPos(0))
endfunction

function! s:BoxForEmptyTodoItem()
  call setline('.', substitute(getline('.'), '^\(\s*\).*$', '\1- [ ] ', ''))
  normal! $
endfunction

function! s:RemoveBoxForTodoItem()
  call setline('.', substitute(getline('.'), '^\(\s*\)-\s*\[.\]\s*\(.*\)$', '\1- \2', ''))
  call cursor(line('.'), s:NewColPos(s:boxlen))
endfunction

function! s:BoxForListItemOrTopic()
  call setline('.', substitute(getline('.'), '^\(\s*-\s*\)\(\S.*\)$', '\1' . s:blank_box . '\2', ''))
  call cursor(line('.'), s:NewColPos(-1 * s:boxlen))
endfunction

function! s:NewColPos(offset)
  let spaces = indent('.')

  if s:save_col <= spaces + len('- ')
    return s:save_col
  elseif s:save_col > spaces + len('- ') + a:offset
    return s:save_col - a:offset
  else
    return spaces + len('- ') + 1
  endif
endfunction
