" memolist
" Version: 0.0.1
" Author: sgur <sgurrr+vim@gmail.com>
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim


if get(g:, 'loaded_ctrlp', 0)
  command! -nargs=? -complete=dir CtrlPMemoList
        \ let g:ctrlp#memolist#path = <q-args> | call ctrlp#init(ctrlp#memolist#id())
endif


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
