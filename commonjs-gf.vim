
function! InitJavaScript()
  setl suffixesadd+=.js
  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  exec "setl path+=". node_modules
  "let project_root=findfile('package.json', expand('%:p:h') . ';')
  "exec "setl path+=". fnamemodify(project_root, ':p:h') . "/node_modules"
endfunction

autocmd FileType javascript call InitJavaScript()

function! CommonJSGFOpen(filepath)
  " The directory name (e.g. FILE_NAME) is passed as the parameter
  let filename = a:filepath
  if isdirectory(filename)

    if filereadable(filename . "/package.json")

      " node_modules.
      let pkg = readfile(filename . '/package.json')
      let main = matchstr(pkg, '"main" *: *"\([^"]\+\)"')
      let main = substitute(main, '.*"main" *: *"', '', '')
      let main = substitute(main, '".*', '', '')
      if main == ""
        let main = "index.js"
      endif
      let filename = filename . "/" . main
      if !filereadable(filename)
        let filename = filename . '.js'
      endif
      if !filereadable(filename)
        echoerr "Can't open file: " . filename
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
