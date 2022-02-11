if exists('b:did_ftplugin') | finish | endif

call tada#init#Init()

function! s:IsTodoItem(line)
  return tada#IsTodoItem(a:line)
endfunction

function! s:IsTopic()
  return getline('.') =~# '^\s*-\s*.*:$'
endfunction

function! s:IsEmptyIndentable()
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
nnoremap <silent> <buffer> <C-B> :call tada#box#Toggle()<CR>
inoremap <silent> <buffer> <script> <expr> <C-B> ' <BS><C-O>:call tada#box#Toggle()<CR>'
inoremap <silent> <buffer> <script> <expr> <C-E> '<C-O>:call tada#map#EmptyLine()<CR>'
inoremap <silent> <buffer> <script> <expr> <Tab> <SID>IsEmptyIndentable() ? '<C-T>' : '<Tab>'
inoremap <silent> <buffer> <script> <expr> <S-Tab> <SID>IsEmptyIndentable() ? '<C-D>' : '<S-Tab>'
inoremap <silent> <buffer> <script> <expr> <CR> <SID>HandleCR()
nnoremap <silent> <buffer> <script> <expr> o <SID>Handleo()
nnoremap <silent> <buffer> <script> <expr> O <SID>HandleO()

if g:tada_autolines
  setlocal comments=b:\|,b:-
  setlocal formatoptions=tron
end

setlocal commentstring=#\ %s
setlocal ts=2 sw=2 expandtab smarttab
setlocal autoindent
setlocal foldmethod=expr
setlocal foldtext=tada#fold#TextForTopic()
setlocal foldexpr=tada#fold#LevelOfLine(v:lnum)
setlocal fillchars=fold:\ "
setlocal nofoldenable

let b:did_ftplugin = 1
