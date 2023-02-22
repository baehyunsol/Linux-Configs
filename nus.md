- `ls | where size > 10MiB or size < 5KiB`
  - 끝에 `| table` 붙여도 동일.
    - pipeline의 stream이 consume 되지 않았다면 implicit하게 `table`이 붙음
- `ls | sort-by size`
  - 그냥 `sort-by` 언급하고 싶었음
- `ls -l | describe`
  - 결과: `table<name: string, type: string, target: nothing, readonly: bool, size: filesize, created: date, accessed: date, modified: date>`
- `ps | get name`, `ps | select name`
  - `get`은 column만 뽑고, `select`는 해당 column으로 이뤄진 table을 만들어서 반환함
- `ps | get name cpu`, `ps | select name cpu`
  - `select`는 column 2개로 이뤄진 table을 반환
  - 즉, `ps | get name cpu | describe`는 `list<any>`이고,
  - `ps | select name cpu | describe`는 `table<name: string, cpu: float>`임.
- `ps | select name cpu | length`
  - 그냥 `length` 언급하고 싶었음
- `ls | find --regex ".*png"`, `[2 4 3 6 5 8] | filter { |it| ($it mod 2) == 1 }`
  - regex 쓸 때 문법 조심하셈 ㅋㅋ `.`가 ~_any character_~임.
  - table에다가 `find` 쓰면 모든 cell들의 문자열을 다 뒤져서 대응되는 row를 다 반환하는 듯? 반환은 table로 함
  - if a name of an input is not declared, it's `$in`
- `cp *.abc test`
  - 현재 폴더의 `.abc` 확장자를 전부 `test` dir로 옮김
  - 앞에가 파일이름이니까 뒤에도 `test/*.abc` 같은 느낌이어야하지 않나 싶겠지만 그렇지 않음!
  - `mv`도 동일
- `ls | where size < 1KiB and type == file | get name | each { |f| cp $f test }`
  - 현재 dir에서 파일 크기가 1kb 이하인 모든 파일을 `./test`로 복사함!
- `echo "hello" | save test.txt`
  - output redirection 이렇게 함!
  - input으로 넣고 싶으면 `open`한 다음에 pipe로 이으면 됨!
- `let name = "Hyunsol"; echo $"Hello, ($name)"`, `let a = 3;let b = 4; echo $"($a) + ($b) = ($a + $b)"`
  - `let`으로 변수 선언. 변수 접근은 무조건 `$` 붙여야함.
  - string literal 앞의 `$`를 이용해서 formatting 가능. formatting 할 때는 문자열 안의 `()`를 읽음.
- `echo "a, b, c, d, e" | save test.txt; open test.txt | split column ","`
  - `split column`은 table을 반환하고 `split row`는 list를 반환
- `str --help`
  - string과 관련된 유용한 명령어들 쭉 보여줌
- `"a" * 3`, `[11  12] * 7`
- `let files = (ls | where size > 500KiB | get name)`
- `(do {let x = 3; let y = 4; $x + $y}) + (do {let x = 5; let y = 6; $x + $y})`
  - 18
- `open ($nu).config-path`, `open ($nu | get config-path)`
  - `$nu`는 원래 존재하는 변수
  - 저런 식으로 `open`에 variable로 경로 줄 수 있음!
  - `get`이나 `.`이나 동일
- `0x[bf] | into int`
  - 191
- `du`
  - get the size of the directory (recursively)
- `timeit { ls | sort-by name type -i | get name }`

- list
  - `[1 2 3 4 5 6] | get 1`
    - get index 1
  - `[1 2 3 4 5 6] | insert 2 10`, `[1 2 3 4 5 6] | update 2 10`

노트북에 nu 버전이 0.64임... ㅜㅜ

[https://www.nushell.sh/book/command_reference.html](https://www.nushell.sh/book/command_reference.html)

https://www.nushell.sh/blog/2022-12-20-nushell-0.73.html
- 탐나는 feature들이 많이 소개됨

---

# ver 0.73

- ``
