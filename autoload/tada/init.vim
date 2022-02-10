if exists('g:tada_loaded_init_autoload')
  finish
endif
let g:tada_loaded_init_autoload = 1

function! tada#init#Global(str, val)
  if !exists('g:' . a:str)
    execute 'let g:' . a:str . ' = ' . a:val
  endif
endfunction

function! tada#init#BufferGlobal(str, val)
  if exists('b:' . a:str)
    return
  endif

  if exists('g:' . a:str)
    execute 'let b:' . a:str . ' = g:' . a:str
  else
    execute 'let b:' . a:str . ' = ' . a:val
  endif
endfunction

function! tada#init#Init()
  if exists('g:tada_init_initialized')
    return
  endif
  let g:tada_init_initialized = 1

  call tada#init#Settings()
  call tada#config#LoadConfigs()
  call tada#init#TodoConfig()
  call tada#init#ClassFiles()
  call tada#init#Mappings()
endfunction

function! tada#init#ClassFiles()
  if !exists('g:tada_loaded_class_files')
    runtime lib/tada/metadata.vim
    runtime lib/tada/todo.vim
    runtime lib/tada/topic.vim

    let g:tada_loaded_class_files = 1
  end
endfunction

function! tada#init#Settings()
  call tada#init#Global('tada_autolines', 1)
  call tada#init#Global('tada_smart_tab', 1)
endfunction

function! tada#init#Mappings()
  call tada#init#Global('tada_todo_switch_status_mapping', "'<Space>'")
  call tada#init#Global('tada_todo_switch_status_reverse_mapping', "'<C-Space>'")
  call tada#init#Global('tada_map_prefix', "'<C-T>'")
endfunction

function! tada#init#TodoConfig()
  call tada#init#BufferGlobal('tada_todo_style', "'unicode'")

  let statuses = []
  let symbols = {}

  if b:tada_todo_style == 'unicode'
    let statuses = "['blank', 'in_progress', 'done', 'blocked']"
    let symbols = "{ 'blank': ' ', 'in_progress': '•', 'done': '✔', 'blocked': '⚑' }"
  elseif b:tada_todo_style == 'ascii'
    let statuses = "['blank', 'in_progress', 'done', 'blocked']"
    let symbols =  "{ 'blank': ' ', 'in_progress': '-', 'done': 'x', 'blocked': 'o' }"
  elseif b:tada_todo_style == 'simple'
    let statuses = "['blank', 'done']"
    let symbols =  "{ 'blank': ' ', 'done': '✔' }"
  elseif b:tada_todo_style == 'markdown'
    let statuses = "['blank', 'done']"
    let symbols =  "{ 'blank': ' ', 'done': 'x' }"
  endif

  call tada#init#BufferGlobal('tada_todo_statuses', statuses)
  call tada#init#BufferGlobal('tada_todo_symbols', symbols)

  let b:tada_todo_default = b:tada_todo_symbols[b:tada_todo_statuses[0]]
endfunction
