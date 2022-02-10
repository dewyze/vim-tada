if exists('g:tada_loaded_map_autoload')
  finish
endif
let g:tada_loaded_map_autoload = 1

function! tada#map#ToggleBox()
  let group = tada#SyntaxGroupOfLine('.')
  let text = getline('.')
  let save_col = col('.')
  let boxlen = len('[' . tada#todo#DefaultSymbol() . '] ')
  let spaces = indent('.')

  if text =~ '^\s*-\?\s*$'
    call setline('.', substitute(getline('.'), '^\(\s*\).*$', '\1- [ ] ', ''))
    normal! $
  elseif group =~ '^tadaTodoItem'
    call setline('.', substitute(getline('.'), '^\(\s*-\s*\)\[.\]\s*\(\S.*\)$', '\1\2', ''))
    call cursor(line('.'), s:NewColPos(save_col, boxlen))
  elseif group == 'tadaListItem' || group =~ '^tadaTopicTitle'
    call setline('.', substitute(getline('.'), '^\(\s*-\s*\)\(\S.*\)$', '\1[' . tada#todo#DefaultSymbol() . '] \2', ''))
    call cursor(line('.'), s:NewColPos(save_col, -1 * boxlen))
  endif
endfunction

function! s:NewColPos(colpos, offset)
  let spaces = indent('.')

  if a:colpos > spaces + len('- ') + a:offset
    return a:colpos - a:offset
  else
    return spaces + len('- ') + 1
  endif
endfunction
