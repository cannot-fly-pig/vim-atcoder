scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim
function! Login(n,p)
	echo "login now..."
	let login = system("curl -c ".$HOME."/.atcoder-cookie.txt -d name=".a:n." -d password=".a:p." https://arc030.contest.atcoder.jp/login?next_url=https%3A%2F%2Farc030.contest.atcoder.jp%2Fsubmissions%2Fme")
	echo "login!"
endfunction
function! Atcoder(...)
	if filereadable($HOME."/.atcoder-cookie.txt" == 0 && g:atcoder_login == 1)
		echo filereadable($HOME."/.atcoder-cookie.txt")
		call Login(g:atcoder_name,g:atcoder_pass)
	endif
	"htmlの取得
	let text = system("curl -b ".$HOME."/.atcoder-cookie.txt https://".a:1.a:2.".contest.atcoder.jp/tasks/".a:1.a:2."_".a:3)
	let i=1
	let num = []
	let in = []
	let out = []
	let y_out = []
	let t_bool = []
	let bool = "true"
	let s:V= vital#of('vital')
	let s:T= s:V.import('Text.Table')
	unlet s:V
	let s:table = s:T.new({
	    \   'columns': [{}, {}, {}, {}, {}],
	    \   'header':  ['No.', 'IN', 'OUT','your anser','result'],
	    \})
	let ac = ["    _       ____   _","   / \\     / ___| | |","  / _ \\   | |     | |"," / ___ \\  | |___  |_|","/_/   \\_\\  \\____| (_)",""]
	let wa = ["__        __     _      _ ","\\ \\      / /    / \\    | |"," \\ \\ /\\ / /    / _ \\   | |","  \\ V  V /    / ___ \\  |_|","   \\_/\\_/    /_/   \\_\\ (_)",""]
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
		call s:table.add_row(["testcase ".test_num,in[i],out[i],y_out[i],t_bool[i]])
		let i += 1
	endwhile
	if bool == "true"
		let winac = popup_create(ac,{"border": [1, 1, 1, 1],'borderchars': ['-','|','-','|','+','+','+','+'],"moved": "any","line": 15,})
		let winid = popup_create(s:table.stringify(), {"line": 23,"moved": "any"})
	else
		let winwa = popup_create(wa,{"border": [1, 1, 1, 1],'borderchars': ['-','|','-','|','+','+','+','+'],"moved": "any","line": 15,})
		let winid = popup_create(s:table.stringify(), {"line": 23,"moved": "any"})
	endif
endfunction
let &cpo = s:save_cpo
unlet s:save_cpo
command! -nargs=* Atcoder call Atcoder(<f-args>)
