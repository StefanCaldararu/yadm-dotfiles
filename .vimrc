syntax enable
colorscheme default
highlight Comment ctermfg=blue guifg=blue
set tabstop=4

" Custom camelCase / snake_case motions
" c = camelCaseMotion
" s = snakeCaseMotion

function! s:IsWordChar(c) abort
return a:c =~# '\k'
endfunction

function CamelMotion() abort
let l:count = v:count1

while l:count > 0
let l:line = getline('.')
let l:pos = col('.') - 1
let l:len = strlen(l:line)
let l:found = 0

let l:i = l:pos + 1

while l:i < l:len
	let l:c = l:line[l:i]
	
	if !s:IsWordChar(l:c)
	  break
	endif

	if l:c =~# '[A-Z]'
	  call cursor(line('.'), l:i + 1)
	  let l:found = 1
	  break
	endif

	let l:i +=1
endwhile

if l:found
	let l:count -=1
	continue
endif

normal! w

let l:count -= 1

endwhile
endfunction


function SnakeMotion() abort
let l:count = v:count1

while l:count > 0
let l:line = getline('.')
let l:pos = col('.') - 1
let l:len = strlen(l:line)
let l:found = 0

let l:i = l:pos + 1

while l:i < l:len
	let l:c = l:line[l:i]
	
	if !s:IsWordChar(l:c)
	  break
	endif

	if l:c ==# '_'
	  call cursor(line('.'), l:i + 1)
	  let l:found = 1
	  break
	endif

	let l:i +=1
endwhile

if l:found
	let l:count -=1
	continue
endif

normal! w

let l:count -= 1

endwhile
endfunction

nnoremap <silent> c : <C-U> call CamelMotion()<CR>
nnoremap <silent> s : <C-U> call SnakeMotion()<CR>

" Make W behave like x (backwards)
nnoremap W b

" Don't overwrite registers when using x/X
nnoremap x "_x
nnoremap X "_X

" Explicitly allow use of the registers
nnoremap "x ""x
nnoremap "X ""X

