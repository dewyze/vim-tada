if exists('g:tada_loaded_utils_autoload')
  finish
endif
let g:tada_loaded_utils_autoload = 1

function! tada#utils#Camelize(status)
  let name = substitute(a:status, '^\(.\)', '\u&', "")
  return substitute(name, '\(_\|-\| \)\(\w\)', '\u\2', "g")
endfunction
