if exists('loaded_vim_tada')
  finish
endif
let loaded_vim_tada = 1

if !exists('g:tada_todo_pane_map')
  let g:tada_todo_pane_map = '<LocalLeader>td'
endif

if !exists('g:tada_todo_pane_file')
  let g:tada_todo_pane_file = 'Tadafile'
endif

if !exists('g:tada_todo_pane_location')
  let g:tada_todo_pane_location = 'right'
endif

if !exists('g:tada_todo_pane_size')
  let g:tada_todo_pane_size = 'min([float2nr(&columns * 0.33), 60])'
endif

function s:TadaTodoPaneLocation()
  if g:tada_todo_pane_location == 'left'
    return 'topleft vertical '
  elseif g:tada_todo_pane_location == 'top'
    return 'topleft '
  elseif g:tada_todo_pane_location == 'bottom'
    return 'botright '
  else
    return 'botright vertical '
  endif
endfunction

function s:TadaTodoPaneSize()
  return string(eval(g:tada_todo_pane_size))
endfunction

function s:TadaOpenTodoPane()
  let location = s:TadaTodoPaneLocation()
  let size = s:TadaTodoPaneSize()

  let buf_num = bufnr(g:tada_todo_pane_file)
  let buf_win_num = bufwinnr(g:tada_todo_pane_file)
  let is_open = buf_win_num != -1

  if is_open
    execute buf_win_num . ' wincmd w'
    close
  else
    if bufnr(g:tada_todo_pane_file) == -1
      execute location . size . ' new'
      execute 'edit ' . g:tada_todo_pane_file
    else
      execute location . size . ' split'
      execute 'buffer ' . g:tada_todo_pane_file
    endif
  endif
endfunction

execute 'nnoremap <silent> ' . g:tada_todo_pane_map . ' :TadaTodo<CR>'

command -nargs=0 TadaTodo :call <SID>TadaOpenTodoPane()
