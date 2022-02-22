if exists('b:did_ftplugin') | finish | endif

call tada#init#Init()

function! s:IsTodoItem(line)
  return tada#IsTodoItem(a:line)
endfunction

function! s:IsEmptyIndentable()
  return g:tada_smart_tab && getline('.') =~ '^\s*-\s*\%(\[.\]\)\?\s*$'
endfunction

function! s:IsEmptyListOrTodo()
  return getline('.') =~ '^\s*-\s*\%(\[.\]\)\?\s*$'
endfunction

function! s:HandleNormalCR()
  return tada#fold#HandleCR()
endfunction

function! s:HandleInsertCR()
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
nmap <silent> <buffer> <nowait> <script> <expr> <CR> <SID>HandleNormalCR()
nnoremap <silent> <buffer> <C-T>1 :call tada#fold#To(0)<CR>
nnoremap <silent> <buffer> <C-T>2 :call tada#fold#To(1)<CR>
nnoremap <silent> <buffer> <C-T>3 :call tada#fold#To(2)<CR>
nnoremap <silent> <buffer> <C-T>4 :call tada#fold#To(3)<CR>
nnoremap <silent> <buffer> <C-T>5 :call tada#fold#To(4)<CR>
nnoremap <silent> <buffer> <C-T>6 :call tada#fold#To(5)<CR>
nnoremap <silent> <buffer> <C-T>0 :call tada#fold#To(6)<CR>
nnoremap <silent> <buffer> <C-T>o :normal! zO<CR>
nnoremap <silent> <buffer> <C-T>c :normal! zc<CR>
nnoremap <silent> <buffer> <C-B> :call tada#box#Toggle()<CR>
inoremap <silent> <buffer> <script> <expr> <C-B> ' <BS><C-O>:call tada#box#Toggle()<CR>'
inoremap <silent> <buffer> <script> <expr> <C-H> '<C-O>:call tada#map#EmptyLine()<CR>'
inoremap <silent> <buffer> <script> <expr> \| <SID>IsEmptyListOrTodo() ? '\|<C-O>:call tada#map#EmptyLine()<CR> ' : '\|'
inoremap <silent> <buffer> <script> <expr> > <SID>IsEmptyListOrTodo() ? '><C-O>:call tada#map#EmptyLine()<CR> ' : '>'
inoremap <silent> <buffer> <script> <expr> : <SID>IsEmptyListOrTodo() ? '<C-O>S<C-D>- ' : ':'
inoremap <silent> <buffer> <script> <expr> <Tab> <SID>IsEmptyIndentable() ? '<C-T>' : '<Tab>'
inoremap <silent> <buffer> <script> <expr> <S-Tab> <SID>IsEmptyIndentable() ? '<C-D>' : '<S-Tab>'
inoremap <silent> <buffer> <script> <expr> <CR> <SID>HandleInsertCR()
nnoremap <silent> <buffer> <script> <expr> o <SID>Handleo()
nnoremap <silent> <buffer> <script> <expr> O <SID>HandleO()

if g:tada_autolines
  setlocal comments=b:\|,b:-,b:>
  setlocal formatoptions=tron
end

setlocal commentstring=#\ %s
setlocal ts=2 sw=2 sts=2 expandtab smarttab
setlocal autoindent
setlocal foldmethod=expr
setlocal foldtext=tada#fold#TextForTopic()
setlocal foldexpr=tada#fold#Level(v:lnum)
setlocal fillchars=fold:\ "
setlocal foldenable
setlocal foldlevel=6

function s:Hi(group, fg, bg = "")
  if a:fg != ""
    exec "hi " . a:group . " guifg=#" . a:fg
  endif

  if a:bg != ""
    exec "hi " . a:group . " guibg=#" . a:bg
  endif
endfun

call <SID>Hi("tadaArchivedTopic", b:tada_colors["archive"])
call <SID>Hi("tadaTopicTitle1", b:tada_colors["topic"]["1"])
call <SID>Hi("tadaTopicTitle2", b:tada_colors["topic"]["2"])
call <SID>Hi("tadaTopicTitle3", b:tada_colors["topic"]["3"])
call <SID>Hi("tadaTopicTitle4", b:tada_colors["topic"]["4"])
call <SID>Hi("tadaTopicTitle5", b:tada_colors["topic"]["5"])
call <SID>Hi("tadaTopicTitle6", b:tada_colors["topic"]["6"])
call <SID>Hi("tadaInvalidConfig", "ffffff", b:tada_colors["invalid_config"])
call <SID>Hi("tadaComment", b:tada_colors["comment"])
call <SID>Hi("tadaMetadata", b:tada_colors["metadata"])
call <SID>Hi("tadaNote", b:tada_colors["note"])

for status in b:tada_todo_statuses
  let name = tada#utils#Camelize(status)

  if has_key(b:tada_colors["todo"], status)
    let color = substitute(b:tada_colors["todo"][status], '^#', '', '')
    execute 'call <SID>Hi("tadaTodoItem' . name . '", "' . color . '")'
  endif
endfor

let b:did_ftplugin = 1
