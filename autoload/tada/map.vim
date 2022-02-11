if exists('g:tada_loaded_map_autoload')
  finish
endif
let g:tada_loaded_map_autoload = 1

function! tada#map#EmptyLine()
  let curcol = col('.') - 1
  let rest = getline('.')[curcol:-1]
  let spaces = repeat(' ', curcol)
  call setline('.', spaces . rest)
endfunction

function! tada#map#ToggleBox()
  let group = tada#SyntaxGroupOfLine('.')
  let text = getline('.')
  let save_col = col('.')
  let boxlen = len('[' . tada#todo#DefaultSymbol() . '] ')
  let spaces = indent('.')
  let blank_box = '[' . tada#todo#DefaultSymbol() . '] '

  " if line above is todo, put it at the same level
  if text =~ '^\s*$'
    let prev_line_num = line('.') - 1
    if tada#SyntaxGroupOfLine(prev_line_num) =~ '^tadaTodoItem'
      let spaces = repeat(' ', max([indent(prev_line_num), 0]))
      call setline('.', spaces . '- ' . blank_box)
      call cursor(line('.'), s:NewColPos(save_col, 0))
    else
      call setline('.', repeat(' ', spaces) . '- ' . blank_box)
      normal! $
    endif
  elseif text =~ '^\(\s*-\)\@!.\+$'
    let spaces = repeat(' ', max([indent('.') - 6, 0]))
    call setline('.', substitute(getline('.'), '^\(\s*\)\(\S.*\)$', spaces . '- ' . blank_box . '\2', ''))
    call cursor(line('.'), s:NewColPos(save_col, 0))
  elseif text =~ '^\s*-\s*$'
    call setline('.', substitute(getline('.'), '^\(\s*\).*$', '\1- [ ] ', ''))
    normal! $
  elseif group =~ '^tadaTodoItem'
    call setline('.', substitute(getline('.'), '^\(\s*\)-\s*\[.\]\s*\(.*\)$', '\1- \2', ''))
    call cursor(line('.'), s:NewColPos(save_col, boxlen))
  elseif group == 'tadaListItem' || group =~ '^tadaTopicTitle'
    call setline('.', substitute(getline('.'), '^\(\s*-\s*\)\(\S.*\)$', '\1' . blank_box . '\2', ''))
    call cursor(line('.'), s:NewColPos(save_col, -1 * boxlen))
  endif
endfunction

function! s:NewColPos(colpos, offset)
  let spaces = indent('.')

  if a:colpos <= spaces + len('- ')
    return a:colpos
  elseif a:colpos > spaces + len('- ') + a:offset
    return a:colpos - a:offset
  else
    return spaces + len('- ') + 1
  endif
endfunction
