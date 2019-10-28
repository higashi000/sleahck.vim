let s:save_cpo = &cpo
set cpo&vim

function! sleahck#GetChannelHistory(channelName)
  let l:messageData = []

  let l:url = 'http://localhost:8080/sleahck/GetHistory/'.a:channelName

  let sleahckRes = webapi#http#get(l:url)

  let channelHistory = webapi#json#decode(sleahckRes.content)

  for i in channelHistory.msg
    let messageData = add(messageData, i.user.'  '.i.time)
    let messageData = add(messageData, '')
    let messageData = add(messageData, i.text)
    let messageData = add(messageData, '')
    let messageData = add(messageData, '-----------------------------------')
  endfor

  if has('patch-8.1.1594')
    call popup_menu(l:messageData, {
        \ 'maxheight' : 50,
        \ 'moved' : 'any',
        \ 'filter' : 'popup_filter_menu',
        \ })
  else
    let l:fileName = "$HOME/." . a:channelName . ".txt"
    echo l:fileName

    if l:channelID != "0"
      let outputfile = l:fileName
      execute ":redir!>".outputfile
        for i in l:channelHistory
            silent echo i
        endfor
      redir END
      execute ":e" . l:fileName
    elseif l:channelID == "0"
      echo "Wrong Channel Name"
    endif
  endif
endfunction

function! sleahck#DispChannelList()
  let l:channelList = []
  let url = 'http://localhost:8080/sleahck/channelList'
  let l:sleahckRes = webapi#http#get(url)
  let l:res = webapi#json#decode(l:sleahckRes.content)

  for i in l:res
    call add(l:channelList, i.name)
  endfor

  if has('patch-8.1.1594')
    let pos = getpos('.')
    call popup_menu(l:channelList, {
            \ 'line' : line('.') + 2,
            \ 'col' : col('.') + 2,
            \ 'moved' : 'any',
            \ 'filter' : 'popup_filter_menu',
            \ 'callback' : function('sleahck#SelectChannel', [l:channelList])
            \ })
  else
    echo "未実装〜"
  endif
endfunction

function! sleahck#SelectChannel(ctx, id, idx) abort
  if a:idx ==# -1
    return
  endif

  call sleahck#GetChannelHistory(a:ctx[a:idx-1])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
