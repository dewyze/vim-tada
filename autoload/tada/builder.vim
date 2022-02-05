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
  let topicData = {}
  let topicData['line'] = num
  let topicData['level'] = tada#builder#TopicLevel(num)
  let titleResult = tada#builder#Title(num)
  let topicData['title'] = titleResult.value
  let metadataResult = tada#builder#Metadata(titleResult.nextLine)
  let topicData['metadata'] = metadataResult.value
  let descriptionResult = tada#builder#Description(metadataResult.nextLine)
  let topicData['description'] = descriptionResult.value

  return g:TadaTopic.New(topicData)
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

  while !(tada#IsTopicTitle(num)) && !(tada#IsTodoItem(num))
    call add(description, substitute(getline(num), '^\s*', '', ''))
    let num += 1
  endwhile

  return tada#builder#Result(num, description)
endfunction
