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

" Replace root alias name like '@/mode-name' to '<ROOT>/mode-name'
function! ReplaceRootAliasPath(fname)
  let filename = substitute(a:fname, '^@\/', '', '')
  return filename
endfunction

function! InitJSGF()
  setlocal suffixesadd+=.ts,.tsx,.jsx,.vue,.json,.js
  setlocal isfname+=@-@

  let node_modules = finddir('node_modules', expand('%:p:h') . ';')
  let srcRoot = finddir('src', expand('%:p:h') . '.;')
  let pkgJson = findfile('package.json', expand('%:p') . '.;')
  let pkgJsonRoot = '/' . join(split(l:pkgJson, '/')[0:-2], '/')

  execute 'setlocal path+=' . node_modules
  execute 'setlocal path+=' . srcRoot
  execute 'setlocal path+=' . pkgJsonRoot
  set includeexpr=ReplaceRootAliasPath(v:fname)
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

function! GetJSONFieldValue(json, fieldName)
  let re_main = '.*"' . a:fieldName . '"\s*:\s*"\([^"]\+\)".*'
  let s_main = matchstr(a:json, re_main)
  if s_main == ''
    return ''
  endif

  let value = substitute(s_main, re_main, '\1', '')
  return value
endfunction

function! JSGF(filepath, open)
  let filename = a:filepath

  if isdirectory(filename)
    let pkg_file = filename . '/package.json'
    if filereadable(pkg_file)
      " node_modules.
      let pkg = readfile(pkg_file)
      let main = GetJSONFieldValue(pkg, 'module')
      if main == ''
        let main = GetJSONFieldValue(pkg, 'main')
      endif
      if main == ''
        let main = GetJSONFieldValue(pkg, 'browser')
      endif
      if main == ''
        let main = 'index'
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
    echohl ErrorMsg
    echomsg 'E447: Can not find file "' . filename . '" in path [jsgf.vim].'
    echohl None
    return
  endif

  " `:help +cmd`
  " tmp +cmd variable for search and goto target line where define method.
  if !exists('b:jsgf_plus_cmd')
    let b:jsgf_plus_cmd = ''
  endif

  execute a:open b:jsgf_plus_cmd filename
  let b:jsgf_plus_cmd = ''
endfunction

autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue call InitJSGF()
autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue nnoremap <buffer><silent> gf :silent call JSGF('<C-R><C-P>', g:jsgf_option_open)<CR>
autocmd FileType javascript,javascriptreact,typescriptreact,json,typescript,vue nnoremap <buffer><silent> <C-w>gf :silent call JSGF('<C-R><C-P>', 'tabnew')<CR>
