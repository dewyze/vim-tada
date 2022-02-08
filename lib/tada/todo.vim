let s:TadaTodo = {}
let g:TadaTodo = s:TadaTodo

function! s:TadaTodo.New(data)
  let todo = copy(self)

  let todo.line = get(a:data, 'line')
  let todo.status = get(a:data, 'status', 'blank')

  return todo
endfunction
