if exists('g:tada_loaded_autoline_autoload')
  finish
endif
let g:tada_loaded_autoline_autoload = 1

function tada#autoline#ImapCR()
  return tada#autoline#Handle("\<CR>")
endfunction

function! tada#autoline#Nmapo()
  return tada#autoline#Handle("o")
endfunction

function! tada#autoline#NmapO()
  return tada#autoline#Handle("O", 0)
endfunction

function! tada#autoline#Handle(key, on_empty = 1)
  if !g:tada_autolines
    return a:key
  endif

  let empty_pattern = '^\s*\%(-\||\|-\s*\[' . g:tada_todo_symbols['blank'] . '\]\)\s*$'

  if a:on_empty && getline('.') =~ empty_pattern
    return "\<ESC>S\<CR>"
  elseif tada#SyntaxGroupOfLine('.') =~ '^tadaTodoItem'
    return a:key ."[" . g:tada_todo_symbols['blank'] . "] "
  else
    return a:key
  endif
endfunction
