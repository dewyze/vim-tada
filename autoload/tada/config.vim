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
    let text = getline(match)
    let var = matchlist(text, '@config.\(.*\) =')[1]

    call tada#config#Validate(var)

    let cmd = substitute(text, '@config.', 'let b:tada_', '')

    exe cmd
    let match = search(config_pattern, 'W')
  endwhile

  call setpos('.', save_cursor)
endfunction

function! tada#config#Validate(var)
  let valid_configs = ['todo_statuses', 'todo_symbols', 'todo_style', 'count_nested_todos']

  if index(valid_configs, a:var) == -1
    echoerr 'Invalid config: ' . a:var
  endif
endfunction
