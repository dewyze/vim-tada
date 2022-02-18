if exists('g:tada_loaded_fold')
  finish
endif
let g:tada_loaded_fold = 1

function! tada#fold#HandleCR()
  let current = getline('.')
  let is_folded_at = foldclosed('.')

  if current =~ g:tada_pat_topic || current =~ g:tada_pat_archive_header
    return "za"
  elseif is_folded_at > -1 && line('.') != is_folded_at
    return "zv"
  else
    return "<CR>"
  endif
endfunction

function! tada#fold#TextForTopic()
  if getline(v:foldstart) =~ g:tada_pat_archive_header
    return "### ARCHIVE ###"
  else
    let topic = tada#builder#Topic(v:foldstart)

    return topic.FoldText()
  endif
endfunction

function! tada#fold#LevelOfLine(lnum)
  let title_level = tada#TitleLevel(a:lnum)
  let current_line = getline(a:lnum)

  if current_line =~ g:tada_pat_blank_line
    return '='
  elseif current_line =~ g:tada_pat_archive_header
    return '>' . (&foldlevel + 1)
  elseif current_line =~ g:tada_pat_comment
    execute 'return ' . (&foldlevel + 1)
  elseif title_level
    return '>' . title_level
  else
    return (indent(a:lnum) / 2)
  endif
endfunction

function! tada#fold#To(level)
  execute 'setlocal foldlevel=' . (a:level - 1)

  normal! zX
endfunction
