scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! vim-atcoder#Atcoder(...)
	"htmlの取得
	let text = system("curl https://atcoder.jp/contests/".a:1.a:2."/tasks/".a:1.a:2."_".a:3)
	let i=1
	let num = []
	let in = []
	let out = []
	let bool = "AC"
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
	echo in
	let i = 0
	"実行&判定
	let a = system("g++ -std=gnu++03 -O2 -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -o ./a.out ".expand("%"))
	while i < ii-1
		let a = system("echo ".in[i]." | ./a.out")
		echo a." ".out[i]
		if a != out[i]
			let bool = "WC"
		endif
		let i += 1
	endwhile
	echo bool
endfunction
let &cpo = s:save_cpo
unlet s:save_cpo
