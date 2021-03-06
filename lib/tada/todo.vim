let s:TadaTodo = {}
let g:TadaTodo = s:TadaTodo

function! s:TadaTodo.New(data)
  let todo = copy(self)

  let todo.status = get(a:data, 'status', 'blank')

  return todo
endfunction

function! s:TadaTodo.ToJson()
  let todo = copy(self)

  call remove(todo, 'New')
  call remove(todo, 'ToJson')

  return todo
endfunction
