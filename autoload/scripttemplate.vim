"============================================================================
" FILE: autoload/jspre.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
"============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

"#### TemplateSyntax

function! s:scripttemplateSyntaxGroup(filetype)
  let ft = toupper(a:filetype)
  return 'ScriptTemplateCodeGroup'.ft
endfunction

function! s:scripttemplateSyntaxRegion(filetype)
  let ft = toupper(a:filetype)
  return 'ScriptTemplateCodeRegion'.ft
endfunction

function! scripttemplate#loadOtherSyntax(filetype)
  let group = s:scripttemplateSyntaxGroup(a:filetype)

  " syntax save
  if exists('b:current_syntax')
    let s:current_syntax = b:current_syntax
    unlet b:current_syntax
  endif

  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'

  " syntax restore
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif

  return group
endfunction

function! jspretmpl#applySyntax(filetype)
  let group = s:tmplSyntaxGroup(a:filetype)
  let region = s:tmplSyntaxRegion(a:filetype)
  let b:jspre_current_ft = a:filetype
  if &ft == 'javascript' || &ft == 'typescript'
    let regexp_start = '<script type="text/template">'
    let regexp_skip = ''
    let regexp_end = '</script>'
    let group_def = 'start="'.regexp_start.'" skip="'.regexp_skip.'" end="'.regexp_end.'"'
    execute 'syntax region '.region.' matchgroup=ScriptTemplateStrings '.group_def.' keepend contains=@'.group
  else
    return
  endif

endfunction

function! scripttemplate#loadAndApply(...)
  if a:0 == 0
    return
  endif
  let l:ft = a:1
  call scripttemplate#loadOtherSyntax(l:ft)
  call scripttemplate#applySyntax(l:ft)
endfunction

function! scripttemplate#clear()
  if !exists('b:scripttemplate_current_ft')
    return
  endif
  execute 'syntax clear '.s:scripttemplateSyntaxRegion(b:jspre_current_ft)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
