let s:TadaMetadata = {}
let g:TadaMetadata = s:TadaMetadata

function! s:TadaMetadata.New(data)
  let metadata = copy(self)

  let metadata.assignees = get(a:data, '@', '')
  let metadata.end_date = get(a:data, '$', '')
  let metadata.links = get(a:data, '&', '')
  let metadata.points = get(a:data, '#', '')
  let metadata.priority = get(a:data, '!', '')
  let metadata.start_date = get(a:data, '^', '')
  let metadata.status = get(a:data, '?', '')

  return metadata
endfunction
