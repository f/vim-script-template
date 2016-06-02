"============================================================================
" FILE: plugin/jspre.vim
" AUTHOR: Quramy <yosuke.kurami@gmail.com>
"============================================================================

scriptencoding utf-8

if exists('g:loaded_script_template')
  finish
endif
let g:loaded_script_template = 1
let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -complete=filetype ScriptTemplate : call scripttemplate#loadAndApply(<f-args>)
command! ScriptTemplateClear : call scripttemplate#clear()

let &cpo = s:save_cpo
unlet s:save_cpo
