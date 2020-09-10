" Name: jsgf (Goto File imporve for JavaScript)
" Author: 闲耘 <hotoo.cn@gmail.com>
" URL: https://github.com/hotoo/jsgf.vim

if exists('loaded_jsgf_plugin')
	finish
endif
let loaded_jsgf_plugin = 1

if !exists('g:jsgf_option_open')
  let g:jsgf_option_open = 'e'
endif

function! InitJSGF()
  setlocal suffixesadd+=.js,.vue,.json,.jsx,.ts,.tsx
  setlocal isfname+=@-@

  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  let srcRoot = finddir('src', expand('%:p:h') . '.;')
  let pkgJson = findfile('package.json', expand('%:p') . '.;')
  let pkgJsonRoot = '/' . join(split(l:pkgJson, '/')[0:-2], '/')

  execute 'setlocal path+=' . node_modules
  execute 'setlocal path+=' . srcRoot
  execute 'setlocal path+=' . pkgJsonRoot
endfunction

function! FindFileOrDir(filename)
  if filereadable(a:filename)
    return a:filename
  endif

  let suffixes = split(&suffixesadd, ',')
  let suffixes = filter(suffixes, 'count(suffixes, v:val) == 1')

  for s in suffixes
    let candidate = a:filename . s
    if filereadable(candidate)
      return candidate
    endif
  endfor
  return ''
endfunction

function! JSGF(filepath, open)
  let filename = a:filepath

  if isdirectory(filename)
    let pkg_file = filename . '/package.json'
    if filereadable(pkg_file)
      " node_modules.
      let pkg = readfile(pkg_file)
      let main = matchstr(pkg, '"main" *: *"\([^"]\+\)"')
      if main == ''
        " Not set `main` in package.json
        let main = 'index'
      else
        let main = substitute(main, '.*"main" *: *"', '', '')
        let main = substitute(main, '".*', '', '')
      endif
      let filename = filename . '/' . main
    elseif (FindFileOrDir(filename . '/index') != '')
      " relative file path.
      let filename = filename . '/index'
    endif

    let fname = FindFileOrDir(filename)
    if (fname == '')
      let filename = a:filepath
    else
      let filename = fname
    endif

  endif

  if !filereadable(filename) && !isdirectory(filename)
    echoerr 'E447: Can not find file "' . filename . '" in path [jsgf.vim].'
    return
  endif

  execute a:open filename
endfunction

autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue call InitJSGF()
autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue nmap <buffer> gf :call JSGF('<C-R><C-P>', g:jsgf_option_open)<CR><CR>
autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue nmap <buffer> <C-w>gf :call JSGF('<C-R><C-P>', 'tabnew')<CR><CR>
