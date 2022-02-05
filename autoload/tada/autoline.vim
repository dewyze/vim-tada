if exists('g:tada_loaded_autoline_autoload')
  finish
endif
let g:tada_loaded_autoline_autoload = 1

function! tada#autoline#Down()
  let group = tada#SyntaxGroupOfLine('.')

  if group == 'tadaMetadata'
    call tada#autoline#HandleDown('^\s\{0,6}|\s*$', '| ')
  elseif group =~ '^tadaTodoItem'
    call tada#autoline#HandleDown('^\s\{0,6}-\s\?\[.\{-}\]\s*$', '- [ ] ')
  elseif group == 'tadaListItem'
    call tada#autoline#HandleDown('^\s*-\s*$', '- ')
  endif
endfunction

function! tada#autoline#HandleDown(empty_pattern, text)
  let spaces = indent('.')

  if getline('.') =~ a:empty_pattern
    call append('.', repeat(' ', spaces))
    execute "normal! 0Dj$"
  else
    execute 'normal! o' . a:text
  endif
endfunction

function! tada#autoline#Up()
  let group = tada#SyntaxGroupOfLine('.')

  if group == 'tadaMetadata'
    call tada#autoline#HandleUp('| ')
  elseif group =~ '^tadaTodoItem'
    call tada#autoline#HandleUp('- [ ] ')
  elseif group =~ 'tadaListItem'
    call tada#autoline#HandleUp('- ')
  endif
endfunction

function! tada#autoline#HandleUp(text)
  execute 'normal! O' . a:text
endfunction