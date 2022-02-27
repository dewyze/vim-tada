if exists('g:tada_loaded_init_autoload')
  finish
endif
let g:tada_loaded_init_autoload = 1

function! tada#init#Global(str, val)
  if !exists('g:' . a:str)
    let g:[a:str] = a:val
  endif
endfunction

function! tada#init#BufferGlobal(str, val)
  if exists('b:' . a:str)
    return
  endif

  if exists('g:' . a:str)
    let b:[a:str] = get(g:, a:str)
  else
    let b:[a:str] = a:val
  endif
endfunction

function! tada#init#Init()
  call tada#init#Patterns()
  call tada#init#Settings()
  call tada#config#LoadConfigs()
  call tada#init#TodoConfig()
  call tada#init#ClassFiles()
  call tada#init#Mappings()
  call tada#init#Colors()
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
  call tada#init#BufferGlobal('tada_count_nested_todos', 1)
endfunction

function! tada#init#Mappings()
  call tada#init#Global('tada_todo_switch_status_mapping', "<Space>")
  call tada#init#Global('tada_todo_switch_status_reverse_mapping', "<C-Space>")
  call tada#init#Global('tada_map_prefix', "<C-T>")
endfunction

function! tada#init#TodoConfig()
  call tada#init#TodoStyle()
  call tada#init#StatusesAndSymbols()
  call tada#init#BufferGlobal('tada_todo_statuses', s:statuses)
  call tada#init#BufferGlobal('tada_todo_symbols', s:symbols)
  call tada#init#ValidateTodoConfig()

  let b:tada_todo_default = b:tada_todo_symbols[b:tada_todo_statuses[0]]
endfunction

function! tada#init#TodoStyle()
  if exists("b:tada_todo_symbols")
    let b:tada_todo_style = "custom"
  elseif exists("b:tada_todo_style") && index(["unicode", "ascii", "simple", "markdown"], b:tada_todo_style) < 0
    echoerr "Invalid @config.todo_style: " . b:tada_todo_style
    let b:tada_todo_style = 'unicode'
  else
    call tada#init#BufferGlobal('tada_todo_style', 'unicode')
  endif
endfunction

function! tada#init#StatusesAndSymbols()
  if b:tada_todo_style == 'ascii'
    let s:statuses = ['blank', 'in_progress', 'done', 'blocked']
    let s:symbols =  { 'blank': ' ', 'in_progress': '-', 'done': 'x', 'blocked': 'o' }
  elseif b:tada_todo_style == 'simple'
    let s:statuses = ['blank', 'done']
    let s:symbols =  { 'blank': ' ', 'done': '✔' }
  elseif b:tada_todo_style == 'markdown'
    let s:statuses = ['blank', 'done']
    let s:symbols =  { 'blank': ' ', 'done': 'x' }
  else " 'unicode'
    let s:statuses = ['blank', 'in_progress', 'done', 'blocked']
    let s:symbols = { 'blank': ' ', 'in_progress': '•', 'done': '✔', 'blocked': '⚑' }
  endif
endfunction

function! tada#init#ValidateTodoConfig()
  for status in b:tada_todo_statuses
    if !has_key(b:tada_todo_symbols, status)
      echoerr 'Todo status does not have symbol: ' . status

      let b:tada_todo_style = 'unicode'
      let b:tada_todo_statuses = ['blank', 'in_progress', 'done', 'blocked']
      let b:tada_todo_symbols = { 'blank': ' ', 'in_progress': '•', 'done': '✔', 'blocked': '⚑' }

      break
    endif
  endfor
endfunction

function! tada#init#Colors()
  let salmon = "e69ca0"
  let red = "cc6666"
  let orange = "de935f"
  let yellow = "f0c674"
  let canary = "bfbc91"
  let green = "84b97c"
  let jade = "4bb1a7"
  let aqua = "639ee4"
  let blue = "81a2be"
  let royal = "648cb4"
  let purple = "b294bb"
  let gray = "969896"
  let white = "ffffff"

  let tada_colors = {
  \   "archive": gray,
  \   "comment": gray,
  \   "invalid_config": red,
  \   "metadata": jade,
  \   "note": canary,
  \   "todo": {
  \     "in_progress": yellow,
  \     "done": green,
  \     "blocked": red,
  \   },
  \   "topic": {
  \     "1": purple,
  \     "2": royal,
  \     "3": orange,
  \     "4": purple,
  \     "5": royal,
  \     "6": orange,
  \   },
  \ }

  if exists("g:tada_colors")
    call extend(tada_colors, g:tada_colors)
  endif

  if exists("b:tada_todo_colors")
    let tada_colors["todo"] = b:tada_todo_colors
  endif

  let b:tada_colors = tada_colors
endfunction

function! tada#init#Patterns()
  let g:tada_pat_archive = '^\s*=.*$'
  let g:tada_pat_archive_header = '^\s*===.*$'
  let g:tada_pat_blank_line = '^\s*$'
  let g:tada_pat_buffer_config = '^\s*@config\.[^ ]\+\s\?=\s\?.\+$'
  let g:tada_pat_comment = '^\s*#.*$'
  let g:tada_pat_description = '^\s*[^ \-|>]\+.*$'
  let g:tada_pat_invalid_config = '^\s*@config\..*$'
  let g:tada_pat_list_item = '^\s*-\s*[^ [].*\(:\)\@<!$'
  let g:tada_pat_list_item_empty = '^\s*-\s*$'
  let g:tada_pat_list_item_end = '\(:\)\@<!$'
  let g:tada_pat_list_item_start = '^\s*-\s*[^ []'
  let g:tada_pat_metadata = '^\s\{2,}|.*$'
  let g:tada_pat_no_dash = '^\s*[^ -=].*$'
  let g:tada_pat_note = '^\s*>.*'
  let g:tada_pat_todo_item = '^\s*-\s*\[.\].*$'
  let g:tada_pat_topic = '^\s*-.*:$'
endfunction
