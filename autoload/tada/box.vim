if exists('g:tada_loaded_box_autoload')
  finish
endif
let g:tada_loaded_box_autoload = 1

function! tada#box#Toggle()
  let group = tada#SyntaxGroupOfLine('.')
  let text = getline('.')
  let s:save_col = col('.')
  let s:blank_box = '[' . tada#todo#DefaultSymbol() . '] '
  let s:box = '- ' . s:blank_box
  let s:blank_boxlen = len(s:blank_box)
  let s:boxlen = len(s:box)
  let s:prev_line_num = line('.') - 1

  if text =~ g:tada_pat_blank_line && tada#SyntaxGroupOfLine(s:prev_line_num) =~ '^tadaTodoItem'
    call s:BoxForBlankLinkBelowTodo()
  elseif text =~ g:tada_pat_blank_line
    call s:BoxForBlankLinkNotBelowTodo()
  elseif text =~ '^\s*\%(>\||\|#\).*$'
    call s:BoxForSymbolLine()
  elseif text =~ '^\%(\s*-\)\@!.\+$'
    call s:BoxForDescriptionLine()
  elseif text =~ g:tada_pat_list_item_empty
    call s:BoxForEmptyTodoItem()
  elseif text =~ g:tada_pat_list_item_start
    call s:BoxForListItemOrTopic()
  elseif text =~ g:tada_pat_todo_item
    call s:RemoveBoxForTodoItem()
  endif
endfunction

function! s:BoxForBlankLinkBelowTodo()
  let spaces = repeat(' ', max([indent(s:prev_line_num), 0]))
  call setline('.', spaces . s:box)
  call cursor(line('.'), s:NewColPos(0))
endfunction

function! s:BoxForBlankLinkNotBelowTodo()
  let spaces = indent('.')
  call setline('.', repeat(' ', spaces) . s:box)
  call cursor(line('.'), col('$'))
endfunction

function! s:BoxForSymbolLine()
  let spaces = s:PreviousDashIndent()

  call setline('.', substitute(getline('.'), '^\%(\s*\)\%(\%(>\||\|#\)\s\?\)\(.*\)$', spaces . s:box . '\1', ''))
  call cursor(line('.'), s:NewColPos(-1 * s:boxlen))
endfunction

function! s:BoxForDescriptionLine()
  let spaces = s:PreviousDashIndent()

  call setline('.', substitute(getline('.'), '^\%(\s*\)\(\S.*\)$', spaces . s:box . '\1', ''))
  call cursor(line('.'), s:NewColPos(-1 * s:boxlen))
endfunction

function! s:BoxForEmptyTodoItem()
  call setline('.', substitute(getline('.'), '^\(\s*\).*$', '\1' . s:box, ''))
  call cursor(line('.'), col('$'))
endfunction

function! s:RemoveBoxForTodoItem()
  call setline('.', substitute(getline('.'), '^\(\s*\)-\s*\[.\]\s*\(.*\)$', '\1- \2', ''))
  call cursor(line('.'), s:NewColPos(s:blank_boxlen))
endfunction

function! s:BoxForListItemOrTopic()
  call setline('.', substitute(getline('.'), '^\(\s*-\s*\)\(\S.*\)$', '\1' . s:blank_box . '\2', ''))
  call cursor(line('.'), s:NewColPos(-1 * s:blank_boxlen))
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

function! s:PreviousDashIndent()
  let prev_indent_line = search('^\s*-', 'bnW')
  if prev_indent_line == 0
    let spaces = indent('.') - s:boxlen
  else
    let spaces = indent(prev_indent_line)
  endif

  return repeat(' ', spaces)
endfunction
