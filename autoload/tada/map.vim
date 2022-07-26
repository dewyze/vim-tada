if exists('g:tada_loaded_map_autoload')
  finish
endif
let g:tada_loaded_map_autoload = 1

function! tada#map#EmptyLine()
  let current = getline(".")

  if current =~ '\s*' . g:tada_sigil . '\s*$'
    let sigil_index = match(current, g:tada_sigil)
    let spaces = repeat(' ', sigil_index + 2)
    call setline('.', spaces)
    call setpos('.', [0, line('.'), col('$'), 0])
  else
    let curcol = col('.') - 1
    let rest = getline('.')[curcol:-1]
    let spaces = repeat(' ', curcol)
    call setline('.', spaces . rest)
  endif
endfunction
