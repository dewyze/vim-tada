let s:TadaTopic = {}
let g:TadaTopic = s:TadaTopic

function! s:TadaTopic.New(data)
  let topic = copy(self)

  let topic['line'] = a:data.line
  let topic['level'] = a:data.level
  let topic['title'] = a:data.title
  let topic['metadata'] = a:data.metadata
  let topic['description'] = a:data.description
  let topic['todos'] = []
  let topic['children'] = []

  return topic
endfunction

function! s:TadaTopic.FoldText()

  let foldText = '- '

  let foldText .= repeat(' ', (self.level - 1) * 2)
  let foldText .= self.title . ': '
  let foldText .= self.metadata.status
  return foldText
endfunction
