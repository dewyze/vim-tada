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
    return ":call setpos('.', [0, " . is_folded_at . ", '$', 0])\<CR>zv"
  else
    return "\<CR>"
  endif
endfunction

function! tada#fold#TextForTopic()
  let text = getline(v:foldstart)

  if text =~ g:tada_pat_archive_header
    if text =~ '^\s*===\s*$'
      return "### ARCHIVE ###"
    else
      return substitute(text, '^\s*===\s*\(.*\)$', '### \1 ###', '')
    endif
  else
    let topic = tada#builder#Topic(v:foldstart)

    return topic.FoldText()
  endif
endfunction

function! tada#fold#Level(lnum)
  let title_level = tada#TitleLevel(a:lnum)
  let current_line = getline(a:lnum)

  if current_line =~ g:tada_pat_blank_line || current_line =~ g:tada_pat_no_dash
    return '='
  elseif current_line =~ g:tada_pat_archive_header
    return '>' . (&foldlevel + 1)
  elseif current_line =~ g:tada_pat_archive
    return &foldlevel + 1
  elseif title_level > 0
    return '>' . title_level
  else
    return (indent(a:lnum) / 2)
  endif
endfunction

function! tada#fold#To(level)
  execute 'setlocal foldlevel=' . a:level

  normal! zX
endfunction
