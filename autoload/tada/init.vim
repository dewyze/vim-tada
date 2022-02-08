if exists('g:tada_loaded_init_autoload')
  finish
endif
let g:tada_loaded_init_autoload = 1

function! tada#init#Global(str, val)
  if !exists('g:' . a:str)
    execute 'let g:' . a:str . ' = ' . "'" . a:val . "'"
  endif
endfunction

function! tada#init#Init()
  if !exists('g:tada_loaded_class_files')
    runtime lib/tada/metadata.vim
    runtime lib/tada/todo.vim
    runtime lib/tada/topic.vim

    let g:tada_loaded_class_files = 1
  end

  call tada#init#Global('tada_todo_switch_status_mapping', "<Space>")
  call tada#init#Global('tada_todo_switch_status_reverse_mapping', "<C-Space>")
  call tada#init#Global('tada_map_prefix', "<C-T>")
  call tada#init#Global('tada_autolines', 1)
  call tada#init#Global('tada_smart_tab', 1)
endfunction
