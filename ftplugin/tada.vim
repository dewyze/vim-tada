if exists('b:did_ftplugin') | finish | endif

if !exists('g:tada_todo_switch_status_mapping')
  let g:tada_todo_switch_status_mapping = '<Space>'
endif

if !exists('g:tada_todo_switch_status_reverse_mapping')
  let g:tada_todo_switch_status_reverse_mapping = '<C-Space>'
endif

if !exists('g:tada_map_prefix')
  let g:tada_map_prefix = '<C-T>'
endif

if !exists('g:tada_autolines')
  let g:tada_autolines = 1
endif

if !exists('g:tada_smart_tab')
  let g:tada_smart_tab = 1
endif

function! s:IsTodoItem(line)
  return tada#IsTodoItem(a:line)
endfunction

function! s:IsTopic()
  return getline('.') =~# '^\s*-\s*.*:$'
endfunction

function! s:EmptyTodo()
  return '- [' . g:tada_todo_symbols['todo'] . '] '
endfunction

function! s:EmptyIndentable()
  return g:tada_smart_tab && getline('.') =~ '^\s*-\s*\%(\[.\]\)\?\s*$'
endfunction

function! s:DoesHandleAutoline()
  if !g:tada_autolines
    return 0
  endif

  return getline('.') =~ '^\s*\%(-|\|\)'
endfunction

execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_mapping . ' :call tada#NextTodoStatus()<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_reverse_mapping . ' :call tada#PreviousTodoStatus()<CR>'
nmap <silent> <buffer> <nowait> <script> <expr> <CR> <SID>IsTopic() ? 'za' : '<CR>'
" nmap <silent> <buffer> <nowait> <script> <expr> <CR> <SID>IsTodoItem() ? 'za' : '<CR>'
nnoremap <silent> <buffer> <C-T>1 :call tada#fold#To(1)<CR>
nnoremap <silent> <buffer> <C-T>2 :call tada#fold#To(2)<CR>
nnoremap <silent> <buffer> <C-T>3 :call tada#fold#To(3)<CR>
nnoremap <silent> <buffer> <C-T>o :normal! zv<CR>
nnoremap <silent> <buffer> <C-T>O :normal! zR<CR>
inoremap <silent> <buffer> <script> <expr> <Tab> <SID>EmptyIndentable() ? '<C-T>' : '<Tab>'
inoremap <silent> <buffer> <script> <expr> <S-Tab> <SID>EmptyIndentable() ? '<C-D>' : '<S-Tab>'
inoremap <silent> <buffer> <script> <expr> <C-B> <SID>EmptyTodo()
inoremap <silent> <buffer> <script> <expr> <CR> <SID>DoesHandleAutoline() ? '<C-O>:call tada#autoline#Down()<CR>' : '<CR>'
nnoremap <silent> <buffer> <script> <expr> o <SID>DoesHandleAutoline() ? ':call tada#autoline#Down()<CR>a' : 'o'
nnoremap <silent> <buffer> <script> <expr> O <SID>DoesHandleAutoline() ? ':call tada#autoline#Up()<CR>a' : 'O'

setlocal ts=2 sw=2 expandtab smarttab
setlocal autoindent
set foldmethod=expr
setlocal foldtext=tada#fold#TextForTopic()
setlocal foldexpr=tada#fold#LevelOfLine(v:lnum)
set fillchars=fold:\ "

if !exists('g:tada_loaded_class_files')
  runtime lib/tada/metadata.vim
  runtime lib/tada/todo.vim
  runtime lib/tada/topic.vim

  let g:tada_loaded_class_files = 1
end

let b:did_ftplugin = 1
