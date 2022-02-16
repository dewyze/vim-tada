let s:TadaTopic = {}
let g:TadaTopic = s:TadaTopic

function! s:TadaTopic.New(data)
  let topic = copy(self)

  let topic['line'] = a:data.line
  let topic['level'] = a:data.level
  let topic['title'] = a:data.title
  let topic['metadata'] = a:data.metadata
  let topic['description'] = a:data.description
  let topic['todos'] = a:data.todos
  let topic['children'] = []

  return topic
endfunction

function! s:TadaTopic.ToJson()
  let topic = copy(self)

  call remove(topic, 'FoldText')
  call remove(topic, 'New')
  call remove(topic, 'ToJson')
  call remove(topic, 'MapTodo')
  let topic["metadata"] = topic["metadata"].ToJson()

  # TODO: This should just gather data about todos, counts, etc.

  let topic["todos"] = map(topic["todos"], s:TadaTopic.MapTodo)

  return topic
endfunction

function! s:TadaTopic.MapTodo(idx, todo)
  return a:todo.ToJson()
endfunction

function! s:TadaTopic.FoldText()

  let fold_text = repeat(' ', (self.level - 1) * 2)
  let fold_text .= '- '
  let fold_text .= self.title . ': '
  let strings = []

  if self.metadata.status != ''
    let strings = add(strings, '*' . self.metadata.status . '*')
  endif

  let s:todo_counts = {}

  for status in b:tada_todo_statuses
    let s:todo_counts[status] = 0
  endfor

  for todo in self.todos
    let s:todo_counts[todo.status] += 1
  endfor

  for status in b:tada_todo_statuses
    let strings += s:TodoStringFor(status)
  endfor

  let fold_text .= join(strings, ', ')

  return fold_text
endfunction

function! s:TodoStringFor(status)
  let count = s:todo_counts[a:status]

  if count > 0
    return [count .'[' . b:tada_todo_symbols[a:status] . ']']
  endif

  return []
endfunction
