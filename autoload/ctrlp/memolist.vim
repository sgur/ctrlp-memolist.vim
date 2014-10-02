" =============================================================================
" File:          autoload/ctrlp/memolist.vim
" Description:   MemoList extension
" =============================================================================

" Load guard
if get(g:, 'loaded_ctrlp_memolist', 0) || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_memolist = 1


call add(g:ctrlp_ext_vars, {
  \ 'init': 'ctrlp#memolist#init()',
  \ 'accept': 'ctrlp#memolist#accept',
  \ 'lname': 'memolist',
  \ 'sname': 'memo',
  \ 'type': 'tabe',
  \ 'sort': 0,
  \ 'specinput': 0,
  \ })


let s:memo = {
      \   'last_update' : 0
      \ , 'entries' : []
      \ }


" ctrlp#memolist#init()
"
" Return: List of {title}\t{path}
"
function! ctrlp#memolist#init()
  let g:ctrlp#memolist#path = fnamemodify(get(g:, 'ctrlp#memolist#path', g:memolist_path), ':p')
  let suffix = get(g:, 'memolist_memo_suffix', 'markdown')
  let files = globpath(g:ctrlp#memolist#path, '*.' . suffix, 1, 1)
  let last_modified = max(map(copy(files), 'getftime(v:val)'))
  if len(files) != len(s:memo.entries) || s:memo.last_update < last_modified
    let s:memo.entries = s:entrylist(files)
    let s:memo.last_update = last_modified
  endif
  return s:memo.entries
endfunction


function! s:entrylist(files)
    let entries = map(copy(a:files), 's:header_values(v:val)')
    let max = max(map(copy(entries), 'strdisplaywidth(v:val)'))
    let _ = []
    for [f, e] in s:zip(a:files, entries)
      let _ += [printf('%s%s	(%s)', e, s:padding(e, max), fnamemodify(f, ':t'))]
    endfor
    return _
endfunction


function! s:zip(list1, list2)
  let _ = []
  for i in range(min([len(a:list1), len(a:list2)]))
    let _ += [[a:list1[i], a:list2[i]]]
  endfor
  return _
endfunction


function! s:padding(str, width)
  return repeat(" ", a:width - strdisplaywidth(a:str))
endfunction


function! s:header_values(path)
  let attr = s:format(s:parse(a:path, s:get_headers()))

  if has_key(attr, 'title')
    let title = attr.title
    call remove(attr, 'title')
  else
    let title = fnamemodify(a:path, ':t')
  endif
  return title . ' ' . join(map(keys(attr), 'attr[v:val]'), ' ')
endfunction


function! s:parse(path, headings)
  let attr = {}
  for l in readfile(a:path, 0, 5)
    let matches = matchlist(l, '\v(' . join(a:headings, '|') . ')\W\s*(.*)')
    if !empty(matches)
      let attr[matches[1]] = matches[2]
    endif
  endfor
  return attr
endfunction


function! s:format(attr)
  let attr = a:attr
  for k in filter(keys(attr), 'attr[v:val] =~ "\\s*\\[.*\\]\\s*"')
    let attr[k] = substitute(attr[k], '\s', '', 'g')
  endfor
  return filter(copy(attr), 'v:val !~ "\\[\\s*\\]"')
endfunction


function! s:get_headers()
  let headers = ['title']
  if get(g:, 'memolist_prompt_tags', 0)
    let headers += ['tags']
  endif
  if get(g:, 'memolist_prompt_categories', 0)
    let headers += ['categories']
  endif
  return headers
endfunction


" ctrlp#memolist#accept()
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#memolist#accept(mode, str)
  call ctrlp#exit()
  let fname = split(a:str, "\t")[-1]
  execute 'edit' expand(g:ctrlp#memolist#path . fname[1: -2] )
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#memolist#id()
  return s:id
endfunction


" vim:nofen:fdl=0:ts=2:sw=2:sts=2

