if exists('g:tada_loaded_fold')
  finish
endif
let g:tada_loaded_fold = 1
let g:tada_fold_level = 3

function! tada#fold#TextForTopic()
  let startLine = getline(v:foldstart)
  let endLine = getline(v:foldstart)

  let topic = tada#builder#Topic(v:foldstart)

  return topic.FoldText()
endfunction

function! tada#fold#LevelOfLine(lnum)
  let matches = matchlist(tada#SyntaxGroupOfLine(a:lnum), '^tadaTopicTitle\(\d\)')

  let title_level = tada#TitleLevel(a:lnum)

  if title_level > 0 && title_level <= g:tada_fold_level
    return '>1'
  endif

  return '='
endfunction

function! tada#fold#To(level)
  let g:tada_fold_level = a:level

  normal! zxzM
endfunction

function! tada#fold#GetTopicLevel(lnum)
  let matches = matchlist(tada#SyntaxGroupOfLine(a:lnum), '^tadaTopicTitle\(\d\)')

  if len(matches) > 0
    return matches[1]
  else
    return 0
  endif
endfunction
