" Name: jsgf (Goto File imporve for JavaScript)
" Author: 闲耘 <hotoo.cn@gmail.com>
" URL: https://github.com/hotoo/jsgf.vim

if exists('loaded_jsgf_plugin')
	finish
endif
let loaded_jsgf_plugin = 1

function! InitJSGF()
  setl suffixesadd+=.js
  setl isfname+=@-@
  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  exec "setl path+=". node_modules
  "let project_root=findfile('package.json', expand('%:p:h') . ';')
  "exec "setl path+=". fnamemodify(project_root, ':p:h') . "/node_modules"
endfunction

function! JSGF(filepath)
  let filename = a:filepath
  if isdirectory(filename)
    let pkg_file = filename . "/package.json"

    if filereadable(pkg_file)

      " node_modules.
      let pkg = readfile(pkg_file)
      let main = matchstr(pkg, '"main" *: *"\([^"]\+\)"')
      if main == ""
        let main = "index.js"
      else
        let main = substitute(main, '.*"main" *: *"', '', '')
        let main = substitute(main, '".*', '', '')
      endif
      let filename = filename . "/" . main
      " package.json:main = xxx, without `.js`
      if !filereadable(filename)
        let filename = filename . '.js'
      endif
      if !filereadable(filename)
        echoerr "E447: Can't find file \"" . filename . "\" in path"
        return
      endif

    else

      " relative file path.
      let filename = filename . '/index.js'

    endif
  endif

  exe 'e' filename
endfunction

autocmd FileType javascript,json call InitJSGF()
autocmd FileType javascript,json nmap <buffer> gf :call JSGF("<C-R><C-P>")<CR>
