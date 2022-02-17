if exists('g:tada_loaded_config_autoload')
  finish
endif
let g:tada_loaded_config_autoload = 1

function! tada#config#LoadConfigs()
  let save_cursor = getcurpos()
  call cursor(1,1)
  let config_pattern = '^@config\.[^ ]\+\s\?=\s\?.\+$'
  let match = search(config_pattern, 'cW')

  while (match > 0)
    let cmd = substitute(getline(match), '@config.', 'let b:tada_', '')

    exe cmd
    let match = search(config_pattern, 'W')
  endwhile

  call setpos('.', save_cursor)
endfunction
