# JSGF: improved `gf` for JavaScript

This plugin improves Vim's `gf` command when navigating JavaScript imports.

Support:

* CommonJS (node_modules, package.json:main, /index.<supported suffixes>)
* Vue.js (*.vue)
* JSON (*.json)
* React (*.jsx)
* TypeScript (*.ts, *.tsx)

## Installation

Vundle:

```viml
Plugin 'hotoo/jsgf.vim'
```
## Usage

- `gf` in normal mode: goto file in current buffer.
- `<C-w>gf` in normal mode: open file in new tab.

## Document

```
:help gf
```

## Options

Maybe you need `autochdir` option in .vimrc

```
set autochdir
```

### g:jsgf_option_open

Open file method, default is 'edit', you can use 'new', 'tabnew', or 'vnew'.

```viml
let g:jsgf_option_open = 'vnew'
```

## Test

`vim ./test/jsgf.test.js` and `gf`, `<Ctrl-o>` to test.

## LICENSE

[MIT](http://hotoo.mit-license.org/)
