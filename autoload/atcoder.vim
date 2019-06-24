scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim
command! -nargs=* Atcoder call s:Atcoder(<f-args>)
function! Atcoder(...)
	"htmlの取得
	let text = system("curl https://atcoder.jp/contests/".a:1.a:2."/tasks/".a:1.a:2."_".a:3)
	let i=1
	let num = []
	let in = []
	let out = []
	let y_out = []
	let t_bool = []
	let bool = "true"
	let comment = []
	let ac = ["    _       ____   _","   / \\     / ___| | |","  / _ \\   | |     | |"," / ___ \\  | |___  |_|","/_/   \\_\\  \\____| (_)"]
	let wa = ["__        __     _      _ ","\\ \\      / /    / \\    | |"," \\ \\ /\\ / /    / _ \\   | |","  \\ V  V /    / ___ \\  |_|","   \\_/\\_/    /_/   \\_\\ (_)"]
	"パース
	while match(text,"入力例.".i) != -1
		call add(num,matchstr(text,"入力例.".i))
		let i += 1
	endwhile
	let ii = 1
	while ii <  i
		let a = matchstr(text,"入力例.".ii.".*出力例.".ii)
		let b = matchstr(text,"出力例.".ii."[^\n]*")
		let a = matchstr(a,"<pre>.*</pre>")
		call add(out,b[21:-2])
		call add(in,a[5:-9])
		let ii += 1
	endwhile
	let i = 0
	"実行&判定
	let a = system("g++ -std=gnu++03 -O2 -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -o ./a.out ".expand("%"))
	while i < ii-1
		let a = system("echo '".in[i]."' | ./a.out")
		call add(y_out,a)
		if a != out[i]
			call add(t_bool,"WA")
			let bool = "false"
		else
			call add(t_bool,"AC")
		endif
		let test_num = i + 1
		call add(comment,"testcase ".test_num." | ".in[i]." | ".out[i]." | ".y_out[i]." | ".bool[i])
		let i += 1
	endwhile
	"for i in comment
	"	echo strlen(i)
	"endfor
	if bool == "true"
		let winac = popup_create(ac,{"moved": "any",})
		let winid = popup_create(comment, {"border": [1, 1, 1, 1],'borderchars': ['-','|','-','|','+','+','+','+'],"moved": "any",})
	else
		let winwa = popup_create(wa,{"moved": "any",})
		let winid = popup_create(comment, {"border": [1, 1, 1, 1],'borderchars': ['-','|','-','|','+','+','+','+'],"moved": "any",})
	endif
endfunction
let &cpo = s:save_cpo
unlet s:save_cpo
