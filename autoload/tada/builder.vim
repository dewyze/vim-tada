if exists('g:tada_loaded_builder_autoload')
  finish
endif
let g:tada_loaded_builder_autoload = 1

function! tada#builder#Topic(lnum)
  let text_lines = {
    \ 'metadata': [],
    \ 'todos': [],
    \ 'topic_lines': [],
    \ }

  let topic_indent = indent(a:lnum)
  let builder_indent = topic_indent + &sw
  let end_line = line('$')
  let lnum = a:lnum + 1
  let curindent = indent(lnum)

  while curindent != topic_indent && lnum <= end_line
    call tada#builder#Line(lnum, text_lines, builder_indent)

    let lnum = lnum + 1
    let curindent = indent(lnum)
  endwhile

  let params = {
    \ 'title': tada#builder#Title(getline(a:lnum)),
    \ 'line': a:lnum,
    \ 'level': tada#TitleLevel(a:lnum),
    \ 'metadata': tada#builder#Metadata(text_lines['metadata']),
    \ 'todos': tada#builder#Todos(text_lines['todos']),
    \ 'children': map(text_lines['topic_lines'], { _, num -> tada#builder#Topic(num) }),
    \ }

  return g:TadaTopic.New(params)
endfunction

function! tada#builder#Line(lnum, lines, indent)
  let text = getline(a:lnum)

  if text !~ '^\s\{' . a:indent . '}\S'
    return
  elseif text =~ '^\s\{' . a:indent . '}-.*:$'
    call add(a:lines['topic_lines'], a:lnum)
  elseif text =~ g:tada_pat_metadata
    call add(a:lines['metadata'], text)
  elseif text =~ g:tada_pat_todo_item
    call add(a:lines['todos'], text)
  endif
endfunction

function! tada#builder#Title(text)
  return matchlist(a:text, '^\s*-\s*\(.*\):$')[1]
endfunction

function! tada#builder#Metadata(lines)
  let metadata = {}

  for text in a:lines
    let matches = matchlist(text, '| \(.\):\(.*\)$')
    let metadata[matches[1]] = matches[2]
  endfor

  return g:TadaMetadata.New(metadata)
endfunction

" function! tada#builder#TopicLevel(lnum)
"   let title_level = tada#TitleLevel(a:lnum)
"
"   if title_level
"     return title_level
"   endif
"
"   return min([indent(a:lnum) / 2, 3])
" endfunction

function! tada#builder#Todos(lines)
  let todos = []

  for text in a:lines
    let matches = matchlist(text, '- \[\([^\]]*\)\]')
    let symbol = matches[1]

    for [key, value] in items(b:tada_todo_symbols)
      if symbol == value
        let params = {}
        let params['status'] = key
        let todo = g:TadaTodo.New(params)

        call add(todos, todo)
        break
      endif
    endfor
  endfor

  return todos
endfunction
