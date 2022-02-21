if exists('g:tada_loaded_fold')
  finish
endif
let g:tada_loaded_fold = 1

function! tada#fold#HandleCR()
  let current = getline('.')
  let is_folded_at = foldclosed('.')

  if line('.') == is_folded_at && current =~ g:tada_pat_commented_topic
    let mark_idx = match(current, '-')
    let end_line = tada#utils#PatternEnd('^[^-]\{' . mark_idx . '}-')

    let Uncomment = tada#utils#StayFunc('tada#fold#Uncomment', [line('.'), end_line])

    return ':call ' . string(Uncomment) . "()\<CR>zo"
  elseif line('.') == is_folded_at
    return 'zv'
  elseif current =~ g:tada_pat_topic
    let spaces = indent('.')
    let end_line = tada#utils#PatternEnd('^\s\{' . spaces . '}\S')

    let Comment = tada#utils#StayFunc('tada#fold#Comment', [spaces, line('.'), end_line])

    return ':call ' . string(Comment) . "()\<CR>zc"
  else
    return "zc"
  endif
endfunction

function! tada#fold#Open(lnum)
  let foldstart = foldclosed(a:lnum)
  let foldend = foldclosedend(a:lnum)

  if getline(line(a:lnum)) =~ g:tada_pat_commented_topic
    let Uncomment = tada#utils#StayFunc('tada#fold#Uncomment', [foldstart, foldend])
    call Uncomment()
  endif

  normal! zo
endfunction

function! tada#fold#Comment(spaces, start, end)
  silent! execute a:start . ',' . a:end . 's/^\s\{' . a:spaces . '}/' . repeat(' ', a:spaces) . '<#> /'
  silent! write
endfunction

function! tada#fold#Uncomment(start, end)
  silent! execute a:start . ',' . a:end . 's/<#> //'
  silent! write
endfunction

function! tada#fold#Level(lnum)
  let title_level = tada#TitleLevel(a:lnum)
  let current = getline(a:lnum)

    if current =~ g:tada_pat_blank_line || current =~ g:tada_pat_no_dash
      return '='
    elseif current =~ g:tada_pat_archive_header
      return '>' . (&foldlevel + 1)
    elseif current =~ g:tada_pat_archive
      return &foldlevel + 1
    elseif current =~ g:tada_pat_comment
      let no_comments = substitute(current, '<#> ', '', 'g')
      let start_index = match(no_comments, '-')
      let indent_level = (&foldlevel * 2)

      if &foldlevel < 6
        if start_index < indent_level && count(current, "<#>") == 1 && current !~ '^\s*<#> \s'
          let level = &foldlevel + 1 + (start_index / 1)
        else
          let level = &foldlevel + 1 + (start_index / 2)
        endif
      else
        if count(current, "<#>") == 1 && current !~ '^\s*<#> \s'
          let level = 7
        else
          let level = 8
        endif
      endif

      if current =~ g:tada_pat_commented_topic
        return '>' . level
      else
        return level
      endif
    elseif title_level
      return '>' . title_level
    else
      return (indent(a:lnum) / 2)
    end
  endif
endfunction


function! tada#fold#KeepCursor(Func)
  let save_cursor = getcurpos()
  call a:Func()
  call setpos('.', save_cursor)
endfunction

function! tada#fold#TextForTopic()
  let foldstart = getline(v:foldstart)

  if foldstart =~ g:tada_pat_archive_header
    return "### ARCHIVE ###"
  elseif foldstart =~ g:tada_pat_topic
    let topic = tada#builder#Topic(v:foldstart)

    return topic.FoldText()
  elseif foldstart =~ g:tada_pat_commented_topic
    let titles = []
    let stripped_start = substitute(foldstart, '<#> ', '', '')
    let start_index = match(stripped_start, '\S')

    for lnum in range(v:foldstart, v:foldend)
      let line_text = getline(lnum)
      if line_text =~ g:tada_pat_commented_topic
        let stripped_line = substitute(line_text, '<#> ', '', 'g')
        let index = match(stripped_line, '\S')

        if start_index == index
          call add(titles, substitute(line_text, '^.*- \(.*\):$', '\1', ''))
        end
      endif
    endfor

    let indent = repeat(' ', match(foldstart, '<#> '))
    if len(titles) > 1
      return indent . '❯❯❯ ' . len(titles) . ' Topics'
    else
      return indent . '❯ ' . join(titles, '/')
    endif
  else
    return ''
  endif
endfunction

function! tada#fold#To(level)
  execute 'setlocal foldlevel=' . a:level

  normal! zX
endfunction
