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


" ctrlp#memolist#init()
"
" Return: List of {title}\t{path}
"
function! ctrlp#memolist#init()
  " Conceal file path
  setlocal concealcursor=n conceallevel=3
  syntax match Conceal /\t.*$/ conceal

  let path = get(g:, 'memolist_path', expand('~/memo'))
  let suffix = get(g:, 'memolist_memo_suffix', 'markdown')
  let files = globpath(path, '*.' . suffix, 1, 1)
  let input = map(files, "matchstr(readfile(v:val, 0, 1)[0], 'title:\\zs.*') . '\t' . v:val")
  return input
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
  execute 'edit' split(a:str, "\t")[-1]
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#memolist#id()
  return s:id
endfunction


" vim:nofen:fdl=0:ts=2:sw=2:sts=2

