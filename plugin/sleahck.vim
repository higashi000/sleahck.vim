if exists('g:loaded_sleahck')
  finish
endif
let g:loaded_sarahck = 1


let s:save_cpo = &cpo
set cpo&vim

command! SleahckChannelList call sleahck#DispChannelList()
command! -nargs=1 SleahckChannelHistory call sleahck#GetChannelHistory(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
