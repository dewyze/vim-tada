let s:TadaTopic = {}
let g:TadaTopic = s:TadaTopic

function! s:TadaTopic.New(data)
  let topic = copy(self)

  let topic['line'] = a:data.line
  let topic['level'] = a:data.level
  let topic['title'] = a:data.title
  let topic['metadata'] = a:data.metadata
  let topic['todos'] = a:data.todos
  let topic['children'] = a:data.children
  let topic['todo_counts'] = topic.CountTodos()

  if b:tada_count_nested_todos
    call topic.MergeTodoCounts()
  endif

  return topic
endfunction

function! s:TadaTopic.ToJson()
  let topic = copy(self)

  call remove(topic, 'FoldText')
  call remove(topic, 'New')
  call remove(topic, 'ToJson')
  call remove(topic, 'CountTodos')
  call remove(topic, 'MergeTodoCounts')
  let topic["metadata"] = topic["metadata"].ToJson()

  let topic["todos"] = map(topic["todos"], { _, todo -> todo.ToJson() })

  return topic
endfunction

function! s:TadaTopic.FoldText()
  let fold_text = repeat(' ', (self.level - 1) * 2)
  let fold_text .= '❯ '
  let fold_text .= self.title . ': '
  let strings = []

  if self.metadata.status != ''
    call add(strings, '*' . self.metadata.status . '*')
  endif

  for status in b:tada_todo_statuses
    let count = self.todo_counts[status]

    if count > 0
      call add(strings, count .'[' . b:tada_todo_symbols[status] . ']')
    endif
  endfor

  let fold_text .= join(strings, ', ')
  return fold_text
endfunction

function! s:TadaTopic.CountTodos()
  let todo_counts = {}

  for status in b:tada_todo_statuses
    let todo_counts[status] = 0
  endfor

  for todo in self.todos
    let todo_counts[todo.status] += 1
  endfor

  return todo_counts
endfunction

function! s:TadaTopic.MergeTodoCounts()
  for child in self.children
    for status in b:tada_todo_statuses
      let self.todo_counts[status] += child.todo_counts[status]
    endfor
  endfor
endfunction
