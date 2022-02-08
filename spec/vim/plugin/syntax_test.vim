let s:debug = 0

function! CursorGroup() abort
  return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

function! CursorHasGroup(group) abort
  return CursorGroup() =~ a:group
endfunction

function! TestSyntax(pattern, group) abort
  let pattern = '\C' . a:pattern
  call cursor(1, 1)
  redraw
  let start_match = search(pattern, 'c') && CursorHasGroup(a:group)
  if s:debug
    redraw | sleep 500m
  endif
  let end_match   = search(pattern, 'e') && CursorHasGroup(a:group)
  if s:debug
    redraw | sleep 500m
  endif
  return start_match && end_match
endfunction

function! ResetConfiguration() abort
  unlet g:tada_todo_symbols
  unlet g:tada_todo_symbols_set
  unlet g:tada_todo_switch_status_mapping
  unlet g:tada_todo_switch_status_reverse_mapping
  unlet g:tada_map_prefix
  unlet g:tada_autolines
  unlet g:tada_smart_tab
endfunction
