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

function! s:TadaTopic.FoldText()

  let fold_text = '- '
  let fold_text .= repeat(' ', (self.level - 1) * 2)
  let fold_text .= self.title . ': '
  let strings = []

  if self.metadata.status != ''
    let strings = add(strings, '*' . self.metadata.status . '*')
  endif

  let s:todo_counts = { 'todo': 0, 'in_progress': 0, 'done': 0, 'blocked': 0 }
  for todo in self.todos
    let s:todo_counts[todo.status] += 1
  endfor

  let strings += s:TodoStringFor('blocked')
  let strings += s:TodoStringFor('todo')
  let strings += s:TodoStringFor('in_progress')
  let strings += s:TodoStringFor('done')

  let fold_text .= join(strings, ', ')

  return fold_text
endfunction

function! s:TodoStringFor(status)
  let count = s:todo_counts[a:status]

  if count > 0
    return [count .'[' . g:tada_todo_symbols[a:status] . ']']
  endif

  return []
endfunction
