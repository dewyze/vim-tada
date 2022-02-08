if exists('b:did_ftplugin') | finish | endif

call tada#init#Init()

function! s:IsTodoItem(line)
  return tada#IsTodoItem(a:line)
endfunction

function! s:IsTopic()
  return getline('.') =~# '^\s*-\s*.*:$'
endfunction

function! s:EmptyTodo()
  return '- [' . g:tada_todo_symbols['blank'] . '] '
endfunction

function! s:EmptyIndentable()
  return g:tada_smart_tab && getline('.') =~ '^\s*-\s*\%(\[.\]\)\?\s*$'
endfunction

function! s:HandleCR()
  return tada#autoline#ImapCR()
endfunction

function! s:Handleo()
  return tada#autoline#Nmapo()
endfunction

function! s:HandleO()
  return tada#autoline#NmapO()
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
inoremap <silent> <buffer> <script> <expr> <CR> <SID>HandleCR()
nnoremap <silent> <buffer> <script> <expr> o <SID>Handleo()
nnoremap <silent> <buffer> <script> <expr> O <SID>HandleO()

if g:tada_autolines
  setlocal comments=b:\|,b:-
  setlocal formatoptions=tron
end

setlocal ts=2 sw=2 expandtab smarttab
setlocal autoindent
set foldmethod=expr
setlocal foldtext=tada#fold#TextForTopic()
setlocal foldexpr=tada#fold#LevelOfLine(v:lnum)
set fillchars=fold:\ "

let b:did_ftplugin = 1
