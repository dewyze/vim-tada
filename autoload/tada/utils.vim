if exists('g:tada_loaded_utils_autoload')
  finish
endif
let g:tada_loaded_utils_autoload = 1

function! tada#utils#Camelize(status)
  let name = substitute(a:status, '^\(.\)', '\u&', "")
  return substitute(name, '\(_\|-\| \)\(\w\)', '\u\2', "g")
endfunction

function! tada#utils#Stay(Func)
  let save_cursor = getcurpos()
  call a:Func()
  call setpos('.', save_cursor)
endfunction

function! tada#utils#StayFunc(func, args)
  return function('tada#utils#Stay', [function(a:func, a:args)])
endfunction
