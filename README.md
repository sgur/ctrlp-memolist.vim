ctrlp-memolist.vim
==================

ctrlp.vim extension for memolist.vim

Description
-----------

`:CtrlPMemoList` can access memolist entries via CtrlP interface.

It displayes title of the entry and you can edit correspoinding memo file.

Demo
----

![](https://dl.dropboxusercontent.com/u/175488/Screenshots/github.com/ctrlp-memolist.vim/CtrlPMemoListDemo.gif)

Requirement
-----------

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)
- [memolist.vim](https://github.com/glidenote/memolist.vim)

Usage
-----

Open default directory (specified by `g:memolist_path`)
```vim
CtrlPMemoList
```
or
```vim
CtrlPMemoList <memolist-directory>
```

Install
-------

### Vundle

```vim
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'glidenote/memolist.vim'
Plugin 'sgur/ctrlp-memolist.vim'
```
and
```vim
PluginInstall
```

License
-------

MIT License

Author
------

sgur

