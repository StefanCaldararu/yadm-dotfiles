syntax enable
" Neovim sets its colorscheme via lazy.nvim (lua/plugins/tempus.lua)
if !has('nvim')
	colorscheme default
	highlight Comment ctermfg=blue guifg=blue
endif
set tabstop=4

" Custom camelCase / snake_case motions
" Both move like w, but also stop at subword boundaries:
"   c = camelCase motion: a capital letter starts a new word (fooBar -> Bar)
"   s = snake_case motion: _ separates words (foo_bar -> bar)
" They work as real motions: 3c, v2s, d2c, y3s, ...

" mode: 'n' normal, 'v' visual, 'o' operator-pending
function! s:SubwordMotion(kind, mode) abort
let l:count = v:count1
let l:start = getpos('.')

if a:mode ==# 'v'
	normal! gv
endif

let l:prev_lnum = line('.')
while l:count > 0
	let l:prev_lnum = line('.')
	let l:line = getline('.')
	let l:len = strlen(l:line)
	let l:i = col('.')
	let l:found = 0

	" Only look for a subword boundary when starting inside a word
	if l:line[l:i - 1] =~# '\k'
		while l:i < l:len && l:line[l:i] =~# '\k'
			let l:c = l:line[l:i]

			if a:kind ==# 'camel' && l:c =~# '[A-Z]'
				let l:found = 1
				break
			endif

			if a:kind ==# 'snake' && l:c ==# '_'
				" Land on the first character after the underscore(s)
				while l:i < l:len && l:line[l:i] ==# '_'
					let l:i += 1
				endwhile
				let l:found = l:i < l:len && l:line[l:i] =~# '\k'
				break
			endif

			let l:i += 1
		endwhile
	endif

	if l:found
		call cursor(line('.'), l:i + 1)
	else
		normal! w
	endif

	let l:count -= 1
endwhile

" Like dw: when the last move wraps to the next line, the operator stops at
" the end of the current line instead of eating the line break
if a:mode ==# 'o' && line('.') > l:prev_lnum
	let l:end = [l:prev_lnum, max([1, col([l:prev_lnum, '$']) - 1])]
	call setpos('.', l:start)
	normal! v
	call cursor(l:end)
endif
endfunction

nnoremap <silent> c :<C-U>call <SID>SubwordMotion('camel', 'n')<CR>
xnoremap <silent> c :<C-U>call <SID>SubwordMotion('camel', 'v')<CR>
onoremap <silent> c :<C-U>call <SID>SubwordMotion('camel', 'o')<CR>
nnoremap <silent> s :<C-U>call <SID>SubwordMotion('snake', 'n')<CR>
xnoremap <silent> s :<C-U>call <SID>SubwordMotion('snake', 'v')<CR>
onoremap <silent> s :<C-U>call <SID>SubwordMotion('snake', 'o')<CR>

" Make W behave like x (backwards)
nnoremap W b

" Don't overwrite registers when using x/X
nnoremap x "_x
nnoremap X "_X

" Explicitly allow use of the registers
nnoremap "x ""x
nnoremap "X ""X

