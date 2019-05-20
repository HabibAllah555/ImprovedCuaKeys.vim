function! KeywordCheck(col)
	return getline('.')[a:col-1] =~# '\k'
endfunction

function! HuntInDirection(where,offset,value)
	let temp=a:where
	while (temp>0)&&(temp<=strwidth(getline('.')))
		if KeywordCheck(temp)==a:value
			return temp
		endif
		let temp=temp+a:offset
	endwhile
	return temp
endfunction
function! LeftFindKeyword()
	let before=col('.')
	let whatToExpect=KeywordCheck(before)
	let offset=0
	if before==1
		let temp=getcurpos()[1]
		if temp==0
			"do nothing
		else
			let temp=temp-1
			call cursor(temp,0)
			call cursor(0,strwidth(getline('.')))
			call LeftFindKeyword()
			return
		endif
	elseif before==(strwidth(getline('.')))
		let before=before
	endif
	if 0
	else
		let newBefore=before-1
		"at end of word
		let findq=KeywordCheck(newBefore)
		if whatToExpect&&findq
			let whatToExpect=0
			let offset=1
		elseif (whatToExpect==0)&&(findq==0)
			let whatToExpect=1
			let offset=1
		elseif (whatToExpect==0)&&findq
			let whatToExpect=0
			let offset=1
		else
			let whatToExpect=1
			let offset=1
		endif
	endif
	let temp=HuntInDirection((before-1),-1,whatToExpect)
	call cursor(0,temp+offset)
endfunction
function! LeftWrap()
	if(col('.')==1)
		let temp=getcurpos()[1]-1
		call cursor(temp,0)
		call cursor(0,1+strwidth(getline('.')))
	else
		call cursor(0,col('.')-1)
	endif
endfunction
function! RightWrap()
	if(col(".")+1== col("$"))
		let temp=getcurpos()[1]+1
		if(temp!=line('$'))
			call cursor(temp,1)
		endif
	else
		call cursor(0,col('.')+1)
	endif
endfunction
function! RightFindKeyword()
	let before=col('.')
	if(before==strwidth(getline('.')))
		let temp=getcurpos()[1]
		if temp+1!=line('$')
			call cursor(temp+1,1)
			call cursor(0,1)
			call RightFindKeyword()
			return
		endif
	endif
	let whatToExpect=KeywordCheck(before)
	let offset=0
	let findq=KeywordCheck(before+1)
	if findq&&whatToExpect
		let whatToExpect=0
	elseif whatToExpect&&(findq==0)
		let whatToExpect=0
	elseif (whatToExpect==0)&&(findq==1)
		let whatToExpect=1
	elseif (whatToExpect==0)&&(findq==0)
		let whatToExpect=1
	endif
	let temp=HuntInDirection(before+1,1,whatToExpect)
	call cursor(0,temp)
endfunction
" shift
" shift+arrow selection
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>
" cut copy paste
vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
map <C-v> pi
imap <C-v> <Esc>pi
imap <C-z> <Esc>ui
" mappings
imap <C-Right> <C-o>:call RightFindKeyword()<CR>
imap <C-Left> <C-o>:call LeftFindKeyword()<CR>

set whichwrap+=<,>,h,l,[,]
