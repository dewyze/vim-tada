if exists('g:tada_loaded_fold')
  finish
endif
let g:tada_loaded_fold = 1

function! tada#fold#HandleCR()
  let current = getline('.')
  let is_folded_at = foldclosed('.')

  if current =~ '^\s*-\s*.*:$' || current =~ '^\s*###\s*$'
    return "za"
  elseif is_folded_at > -1 && line('.') != is_folded_at
    return "zv"
  else
    return "<CR>"
  endif
endfunction

function! tada#fold#TextForTopic()
  let startLine = getline(v:foldstart)
  let endLine = getline(v:foldstart)

  if getline(v:foldstart) =~ '^\s*###\s*$'
    return "### ARCHIVE ###"
  else
    let topic = tada#builder#Topic(v:foldstart)

    return topic.FoldText()
  endif
endfunction

function! tada#fold#LevelOfLine(lnum)
  let title_level = tada#TitleLevel(a:lnum)
  let current_line = getline(a:lnum)

  if current_line =~ '^\s*$'
    return '='
  elseif current_line =~ '^\s*###\s*$'
    return '>' . (&foldlevel + 1)
  elseif current_line =~ '^\s*#'
    execute 'return ' . (&foldlevel + 1)
  elseif title_level
    return '>' . title_level
  else
    return (indent(a:lnum) / 2)
  endif
endfunction

function! tada#fold#To(level)
  execute 'set foldlevel=' . (a:level - 1)

  normal! zX
endfunction
