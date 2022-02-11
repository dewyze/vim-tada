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
