if exists('g:tada_loaded_fold')
  finish
endif
let g:tada_loaded_fold = 1

function! tada#fold#HandleCR()
  let current = getline('.')
  let is_folded_at = foldclosed('.')

  if current =~ g:tada_pat_archive_header
    return "za"
  elseif current =~ g:tada_pat_topic
    if is_folded_at == line('.')
      return "za"
    else
      return "zXza:call tada#fold#KeepCursor(function('tada#fold#Comment'))\<CR>"
    endif
  elseif current =~ g:tada_pat_commented_topic
    return ":call tada#fold#KeepCursor(function('tada#fold#Uncomment'))\<CR>zXzo"
  elseif is_folded_at > -1 && line('.') != is_folded_at
    return "zv"
  else
    return "<CR>"
  endif
endfunction

function! tada#fold#KeepCursor(Func)
  let save_cursor = getcurpos()
  call a:Func()
  call setpos('.', save_cursor)
endfunction

function! tada#fold#Comment()
  let fold_start = foldclosed('.')
  let fold_end = foldclosedend('.')
  silent! execute fold_start . ',' . fold_end . 's/^/# /e'
  silent! write
endfunction

function! tada#fold#Uncomment()
  silent! execute foldclosed('.') . ',' . foldclosedend('.') . 's/# //e'
  silent! write
endfunction

function! tada#fold#TextForTopic()
  let text = getline(v:foldstart)

  if text =~ g:tada_pat_archive_header
    return "### ARCHIVE ###"
  elseif text =~ g:tada_pat_comment
    return substitute(text, '# ', '', '')
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
  elseif current_line =~ g:tada_pat_archive_header || current_line =~ g:tada_pat_commented_topic
    return '>' . (&foldlevel + 2)
  elseif current_line =~ g:tada_pat_archive
    execute 'return ' . (&foldlevel + 2)
  elseif current_line =~ g:tada_pat_comment
    execute 'return ' . (&foldlevel + 2)
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
