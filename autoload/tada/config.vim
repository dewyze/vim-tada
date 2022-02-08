if exists('g:tada_loaded_config_autoload')
  finish
endif
let g:tada_loaded_config_autoload = 1

function! tada#config#LoadConfigs()
  let save_cursor = getcurpos()
  let match = search('^@config\.[^ ]\+\s\?=\s\?.\+$', 'W')

  while (match > 0)
    let cmd = substitute(getline(match), '@config.', 'let b:tada_', '')

    exe cmd
    let match = search('^@config', 'W')
  endwhile

  call setpos('.', save_cursor)
endfunction
