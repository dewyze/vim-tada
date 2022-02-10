if exists('g:tada_loaded_builder_autoload')
  finish
endif
let g:tada_loaded_builder_autoload = 1

function! tada#builder#Result(lnum, value)
  let result = {}
  let result['nextLine'] = a:lnum
  let result['value'] = a:value

  return result
endfunction

function! tada#builder#Topic(lnum)
  let num = a:lnum
  let topic_data = {}
  let topic_data['line'] = num
  let topic_data['level'] = tada#builder#TopicLevel(num)
  let title_result = tada#builder#Title(num)
  let topic_data['title'] = title_result.value
  let metadata_result = tada#builder#Metadata(title_result.nextLine)
  let topic_data['metadata'] = metadata_result.value
  let description_result = tada#builder#Description(metadata_result.nextLine)
  let topic_data['description'] = description_result.value
  let todos_result = tada#builder#Todos(metadata_result.nextLine)
  let topic_data['todos'] = todos_result.value

  return g:TadaTopic.New(topic_data)
endfunction

function! tada#builder#Title(lnum)
  let num = a:lnum
  if tada#IsTopicTitle(num)
    let title = matchlist(getline(num), '^\s*-\s*\(.*\):$')[1]
    return tada#builder#Result(num + 1, title)
  endif

  return tada#builder#Result(num + 1, '')
endfunction

function! tada#builder#Metadata(lnum)
  let num = a:lnum
  let l:metadata = {}

  while tada#SyntaxGroupOfLine(num) == 'tadaMetadata'
    let matches = matchlist(getline(num), '| \(.\):\(.*\)$')
    let l:metadata[matches[1]] = matches[2]
    let num += 1
  endwhile

  return tada#builder#Result(num, g:TadaMetadata.New(l:metadata))
endfunction

function! tada#builder#TopicLevel(lnum)
  if tada#builder#TitleLevel(a:lnum)
    return tada#builder#TitleLevel(a:lnum)
  endif

  return min([indent(a:lnum) / 2, 3])
endfunction

function! tada#builder#TitleLevel(lnum)
  let group = tada#SyntaxGroupOfLine(a:lnum)

  if group == 'tadaTopicTitle1'
    return 1
  elseif group == 'tadaTopicTitle2'
    return 2
  elseif group == 'tadaTopicTitle3'
    return 3
  else
    return 0
  endif
endfunction

function! tada#builder#Description(lnum)
  let num = a:lnum
  let description = []

  while !(tada#IsTopicTitle(num)) && !(tada#IsTodoItem(num)) && num <= line('$')
    call add(description, substitute(getline(num), '^\s*', '', ''))
    let num += 1
  endwhile

  return tada#builder#Result(num, description)
endfunction

function! tada#builder#Todos(lnum)
  let num = a:lnum
  let todos = []

  while tada#IsTodoItem(num)
    let matches = matchlist(getline(num), '- \[\([^\]]*\)\]')
    let symbol = matches[1]

    for [key, value] in items(b:tada_todo_symbols)
      if symbol == value
        let params = {}
        let params['status'] = key
        let params['line'] = num
        let todo = g:TadaTodo.New(params)

        call add(todos, todo)
        break
      endif
    endfor

    let num += 1
  endwhile

  return tada#builder#Result(num, todos)
endfunction
