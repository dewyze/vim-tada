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

  let empty_pattern = '^\s*\%(-\||\|-\s*\[' . b:tada_todo_default . '\]\)\s*$'

  if a:on_empty && getline('.') =~ empty_pattern
    return "\<ESC>S\<CR>"
  elseif getline('.') =~ g:tada_pat_todo_item
    return a:key ."[" . b:tada_todo_default . "] "
  else
    return a:key
  endif
endfunction
