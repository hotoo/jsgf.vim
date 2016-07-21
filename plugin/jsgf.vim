" Name: jsgf (Goto File imporve for JavaScript)
" Author: 闲耘 <hotoo.cn@gmail.com>
" URL: https://github.com/hotoo/jsgf.vim

if exists('loaded_jsgf_plugin')
	finish
endif
let loaded_jsgf_plugin = 1

function! InitJSGF()
  setlocal suffixesadd+=.js,.jsx,.ts,.tsx
  setlocal isfname+=@-@
  " setlocal includeexpr=v:fname.'/index'
  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  execute "setlocal path+=" . node_modules
  " setlocal path+=node_modules
  " let project_root=findfile('package.json', expand('%:p:h') . ';')
  " execute "setlocal path+=". fnamemodify(project_root, ':p:h') . "/node_modules"
endfunction

function! FindFileOrDir(filename)
  let filenames = [
    \ a:filename,
    \ a:filename . '.js',
    \ a:filename . '.jsx',
    \ a:filename . '.ts',
    \ a:filename . '.tsx'
  \ ]
  for fname in filenames
    if filereadable(fname)
      return fname
    endif
  endfor
  return a:filename
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
        " Not set `main` in package.json
        let main = "index"
      else
        let main = substitute(main, '.*"main" *: *"', '', '')
        let main = substitute(main, '".*', '', '')
      endif
      let filename = filename . "/" . main

    else

      if (FindFileOrDir(filename) == filename)
        " relative file path.
        let filename = filename . '/index.js'
      endif

    endif
  endif

  let filename = FindFileOrDir(filename)

  if !filereadable(filename)
    echoerr "E447: Can't find file \"" . filename . "\" in path [jsgf.vim]."
    return
  endif

  execute 'e' filename
endfunction

autocmd FileType javascript,json,typescript call InitJSGF()
autocmd FileType javascript,json,typescript nmap <buffer> gf :call JSGF("<C-R><C-P>")<CR>
