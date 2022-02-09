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

function! ResetVar(var) abort
  if exists(a:var)
    execute 'unlet ' . a:var
  endif
endfunction

function! ResetConfiguration() abort
  call ResetVar("g:tada_todo_symbols")
  call ResetVar("g:tada_todo_style")
  call ResetVar("g:tada_todo_statuses")
  call ResetVar("g:tada_autolines")
  call ResetVar("g:tada_smart_tab")
  call ResetVar("g:tada_todo_switch_status_mapping")
  call ResetVar("g:tada_todo_switch_status_reverse_mapping")
  call ResetVar("g:tada_map_prefix")
endfunction
