
" http://usevim.com/2013/01/04/vim101-jumping/
function! InitJavaScript()
  setl suffixesadd+=.js
  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  exec "setl path+=". node_modules
  "let project_root=findfile('package.json', expand('%:p:h') . ';')
  "exec "setl path+=". fnamemodify(project_root, ':p:h') . "/node_modules"
endfunction

autocmd FileType javascript call InitJavaScript()

function! CommonJSGFOpen(filepath)
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

autocmd FileType javascript nmap gf :call CommonJSGFOpen("<C-R><C-P>")<CR>
