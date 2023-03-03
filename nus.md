[[giant]]Nushell Documents[[/giant]]

[[box]]

[[center]]

[[giant]]Table of Contents[[/giant]]

[[/center]]

[[toc]]

[[/box]]

# Basic Types

[[anchor, id = type binary]][[/anchor]]
## binary

`0x[1f ff]`, `0b[0111 1111 1111 1111]`, `0o[77777]`

incomplete bytes will be left-padded with zeros

[[anchor, id = type bool]][[/anchor]]
## bool

`true`, `false`

[[anchor, id = type closure]][[/anchor]]
## closure

`{|x| $x + 1}`, `{$in + 1}`

In order to directly call a closure, `let foo = {|name| print $"hello ($name)"}; do $foo "Sol"`

`$in` is not the first argument of the closure, it's an input from the pipeline

[[anchor, id = type date]][[/anchor]]
## date

see [here][comdate]

[[anchor, id = type duration]][[/anchor]]
## duration

`1ns`, `1us`, `1ms`, `1sec`, `1min`, `1hr`, `3.14day`, `1wk`

It panics when a duration is longer than `15250.285714wk`

[[anchor, id = type float]][[/anchor]]
## float

64 bits double precision floating point number (I guess)

[[anchor, id = type filesize]][[/anchor]]
## filesize

`1b`: a byte

`1kb`, `1mb`, `1gb`, `1tb`, `1pb`, `1eb`, `1zb`: 1000^n^ bytes

`1kib`, `1mib`, `1gib`, `1tib`, `1pib`, `1eib`, `1zib`: 1024^n^ bytes

[[anchor, id = type int]][[/anchor]]
## int

64 bits signed integer

[[anchor, id = type list]][[/anchor]]
## list

untyped data structure, use json-style syntax

[[anchor, id = type null]][[/anchor]]
## null

`null`

`null | into string` is an empty string.

[[anchor, id = type range]][[/anchor]]
## range

`0..100`

It's a [list]<[int]>. There's no `range` type in Nu.

[[anchor, id = type record]][[/anchor]]
## record

key-value data structure, use json-style syntax

[[anchor, id = type string]][[/anchor]]
## string

`"abcdef"`

`let x = 3; let y = 4; echo $"($x) + ($y) = ($x + $y)"`

[[anchor, id = type table]][[/anchor]]
## table

each row is a record, and each column is a list. if the rows have different types... don't just do that

[[box]]

TODO: 이거 어디에 적지...

`if c { d }` is an expression that returns [null] when `c` is not true

[[/box]]

# Arithmatic Operations

- (lhs: [list]<any>) `++` (rhs: [list]<any>) → [list]<any>
- (lhs: [string]) `+` (rhs: [string]) → [string]
- (l: [list]<T>) `*` (times: [int]) → [list]<T>
- (s: [string]) `*` (times: [int]) → [string]
- (base: [int]) `**` (exp: [int]) → [int]
- (base: [int] | [float]) `**` (exp: [int] | [float]) → [float]
- (lhs: [date][typedate]) `-` (rhs: [date][typedate]) → [duration]
- (val: any) `in` (list: [list]<any>) → [bool]
- (val: any) `not-in` (list: [list]<any>) → [bool]

# Basic Commands

## all

- (l: [list]<T>) | `all` (predicate: [closure]\(T) → [bool]) → [bool]
- (t: [table]) | `all` (predicate: [closure]\(R) → [bool]) → [bool]
  - `R` is a row of `t`

## any

- (l: [list]<T>) | `any` (predicate: [closure]\(T) → [bool]) → [bool]
- (t: [table]) | `any` (predicate: [closure]\(R) → [bool]) → [bool]
  - `R` is a row of `t`

## append

- (l: [list]<T>) | `append` (val: T) → [list]<T>
  - if `T` is `list<U>`, it will unwrap `val`, that means `[1 2 3] | append [1 2 3]` is `[1 2 3 1 2 3]`

## columns

see [values](#values)

- (t: [table]) | `columns` → [list]<[string]>
  - returns the names of the columns in `list<string>`
- (r: [record]) | `columns` → [list]<[string]>
  - returns the names of the columns in `list<string>`

[[anchor, id = command date]][[/anchor]]
## date

[[anchor, id = date format string]][[/anchor]]

| String  | Example         | Explanation                          |
|---------|-----------------|--------------------------------------|
|!![[collapsible, default = hidden]]                               |
| %Y      | 2023            | year (zero-padded 4 digits)          |
| %C      | 20              | year / 100 (zero-padded 2 digits)    |
| %y      | 23              | year % 100 (zero-padded 2 digits)    |
| %m      | 02              | month (zero-padded 2 digits)         |
| %b      | Feb             | month (always 3 characters)          |
| %B      | February        | full month name                      |
| %d      | 27              | day (zero-padded 2 digits)           |
| %e      | 27              | day (space-padded 2 digits)          |
| %a      | Mon             | weekday (always 3 characters)        |
| %A      | Monday          | full weekday                         |
| %w      | 1               | sunday = 0 ... saturday = 6          |
| %u      | 1               | monday = 1 ... sunday = 7            |
| %U      | 09              | week number starting with sunday (0 ~ 53), (zero-padded 2 digits)  |
| %W      | 09              | same as %U, but week 1 starts with the first Monday in that year   |
| %j      | 059             | day of the year (1 ~ 366), (zero-padded 3 digits)                  |
| %D      | 02/28/23        | %m/%d/%y                             |
| %F      | 2023-02-28      | %Y-%m-%d                             |
| %v      | 28-Feb-2023     | %e-%b-%Y                             |
| %H      | 00              | hour (0 ~ 23), (zero-padded 2 digits)     |
| %k      |  0              | hour (0 ~ 23), (space-padded 2 digits)    |
| %I      | 03              | hour (01 ~ 12), (zero-padded 2 digits)    |
| %l      |  3              | hour (01 ~ 12), (space-padded 2 digits)   |
| %P      | pm              | 'am' or 'pm'         |
| %p      | PM              | 'AM' or 'PM'         |
| %M      | 24              | minute (00 ~ 59), (zero-padded 2 digits)  |
| %S      | 30              | second (00 ~ 60), (zero-padded 2 digits)  |
| %f      | 479181892       | fractional seconds (in nanosecond) since the last whole second   |
| [[colspan=3]]TODO... |

### date format

- (date: [date][typedate]) | `date format` (format: [string] = "%a, %d %b %Y %T %z") → [string]
- (date: [string]) | `date format` (format: [string] = "%a, %d %b %Y %T %z") → [string]

- `-l`: list all the format characters
  - see [this table](#dateformatstring)

### date now

- `date now` → [date][typedate]

### date to-record

- (date: [date][typedate]) | `date to-record` → [record]
- (date: [string]) | `date to-record` → [record]

## decode

- (raw: [binary]) | `decode utf-8` → [string]
- (raw: [binary]) | `decode utf-16be` → [string]
- (raw: [binary]) | `decode utf-16le` → [string]
- (raw: [binary]) | `decode euc-kr` → [string]

## drop

see [skip](#skip) and [last](#last)

- (l: [list]<T>) | `drop` (count: [int] = 1) → [list]<T>
  - removes `count` items from the end
- (t: [table]) | `drop` (count: [int] = 1) → [table]
  - removes `count` rows from the end

### drop column

- (t: [table]) | `drop column` (count: [int] = 1) → [table]
  - removes `count` columns from the end (right)

### drop nth

- (l: [list]<T>) | `drop nth` (which: [int] | [range][typerange]<[int]>)* → [list]<T>
  - removes elements with the selected indexes

## each

- (l: [list]<T>) | `each` (func: [closure]\(T) → U) → [list]<U>
  - if `func` returns [null], it skips the index
  - in order to include [null]s, `-k` flag must be given
- (t: [table]) | `each` (func: [closure]\(T) → U) → [list]<U>
  - `T` is the type of `t`'s row
  - the length of the result is the number of the rows, that means `func` is applied to "each" row

flags

- `-k`: keep empty ([null]) value cells

## echo

- `echo` (val: T) → T
  - it returns its argument to the pipeline

## encode

- (s: [string]) | `encode utf-8` → [binary]
- (s: [string]) | `encode utf-16be` → [binary]
- (s: [string]) | `encode utf-16le` → [binary]
- (s: [string]) | `encode euc-kr` → [binary]

## enumerate

- (t: [table]) | `enumerate` → [table]<index: [int], item: Row>
- (l: [list]<T>) | `enumerate` → [table]<index: [int], item: T>
- (r: [record]) | `enumerate` → [table]<index: [int], item: [record]>
  - A record works like a table with a single row

It doesn't work on strings

## filter

- (l: [list]<T>) | `filter` (predicate: [closure]\(T) → [bool]) → [list]<T>
- (t: [table]) | `filter` (predicate: [closure]\(Row) → [bool]) → [table]

## find

- (l: [list]<T>) | `find` (term: T)* → [list]<T>
  - `filter { $in.contain(any of the terms) }`
- (t: [table]) | `find` (term: any)* → [table]
  - `filter { $in.contain(any of the terms) }`
  - filters rows
- (s: [string]) | `find` (term: any)* → [string]
  - it returns `s`, if there's a match
  - otherwise it returns [null]

flags

- `-i`: case-insensitive regex mode
- `-m`: multiline regex mode; \^ and \$ match begin/end of a line
- `-r` (regex: [string]): regex to match with
- `-s`: allow a dot (`.`) to match newlines
- `-v`: invert the match

## first

see [last](#last)

- (l: [list]<T>) | `first` → T
- (l: [list]<T>) | `first` (n: [int]) → [list]<T>
  - returns a list with the first `n` elements of `l`

TODO: `first` on binary data

## get

- (t: [table]) | `get` (n: [int]) → [record]
  - gets `n`th row of `t`
- (t: [table]) | `get` (k: T) → [list]
  - gets column with key `k` in `t`
- (l: [list]<T>) | `get` (n: [int]) → T
  - gets `n`th element of `l`
- (r: [record]) | `get` (k: any) → V
  - key-value search

## group

- (l: [list]<T>) | `group` (size: [int]) → [list]<[list]<T>>
  - `0..20 | group 3` is `[[0, 1, 2], [3, 4, 5], ...]`

## group-by

- (l: [list]<T>) | `group-by` → [record]
  - `[1 1 2 2 3] | group-by` is `{1: [1 1], 2: [2, 2], 3: [3]}`
- (t: [table]) | `group-by` (grouper: ColumnName) → [record]
  - `ls | group-by type` is `{file: TableOfFiles, dir: TableOfDirs, ...}`

## hash

- (s: [string]) | `hash md5` → [string]
- (s: [string]) | `hash sha256` → [string]

flags

- `-b`: returns binary output

## insert

see [upsert]

It panics when the field already exists

- (r: [record]) | `insert` (key: any) (value: any) → [record]
- (t: [table]) | `insert` (key: any) (value: any) → [table]
  - all the cells of the inserted column have the same value
- (l: [list]<T>) | `insert` (index: [int]) (value: T) → [list]<T>

## into

### into binary

TODO

### into bool

- (n: [int] | [float]) | `into bool` → [bool]
  - non-zero for true
- (b: [bool]) | `into bool` → [bool]
- (s: [string]) | `into bool` → [bool]
  - `s` should be a valid representation of a boolean or a number
- (l: [list]<any>) | `into bool` → [list]<[bool]>
  - `each {$in | into bool}`

### into datetime

- (n: [int]) | `into datetime` → [date][typedate]
  - if `n` is small enough, it reads `n` in seconds
    - when `n.to_string().len() <= 10`
    - it doesn't make sense to me... why not just using `n.abs()`?
  - otherwise, `n` is read in milliseconds
- (s: [string]) | `into datetime` → [date][typedate]
  - it's helpful to use the `-f` flag

flags

- `-f` (format: [string]): specify an expected format for parsing strings (eg: "%Y%m%d")
  - see [date format](#dateformatstring)
- `-o` (offset: [int]): specify timezone by offset (eg: "+8", "-4")
- `-l`: show [date format](#dateformatstring)

### into decimal

TODO

### into duration

- (s: [string]) | `into duration` → [duration]
- (d: [duration]) | `into duration` → [duration]
  - use `-c` flag

flags

- `-c` (unit: [string]): "sec", "ms", "min", ...

### into filesize

- (n: [int] | [float]) | `into filesize` → [filesize]
- (s: [string]) | `into filesize` → [filesize]

### into int

- (f: [float]) | `into int` → [int]
  - floor, not round
- (f: [filesize]) | `into int` → [int]
  - into number of bytes
- (d: [date][typedate]) | `into int` → [int]
  - seconds elapsed since the Unix Epoch
- (d: [duration]) | `into int` → [int]
  - nanoseconds
- (s: [string]) | `into int` → [int]
  - see `-r` flag
- (b: [bool]) | `into int` → [int]
- (b: [binary]) | `into int` → [int]

flags

- `-r` (radix: [int]): radix of integer

### into record

- (d: [date][typedate]) | `into record` -> [record]
  - year: [int], month: [int], day: [int], hour: [int], minute: [int], second: [int], timezone: [string]
- (d: [duration]) | `into record` -> [record]
  - year: [int], month: [int], week: [int], day: [int], hour: [int], minute: [int], second: [int], millisecond: [int], microsecond: [int], nanosecond: [int], sign: [string]
  - some fields may be missing
- (l: [list]<any>) | `into record` -> [record]
  - keys of the result are index numbers
  - values of the results are the elements of `l`
- (t: [table]) | `into record` -> [record]
  - keys of the result are index numbers
  - values of the result are the rows of `t`

### into string

- any | `into string` → [string]

flags

- `-d` (digits: [int]): decimal digits to which to round (only for numerics)

## last

see [first](#first)

- (l: [list]<T>) | `last` → T
- (l: [list]<T>) | `last` (n: [int]) → [list]<T>
  - returns a list with the last `n` elements of `l`

## length

- (l: [list]<any>) | `length` → [int]
- (t: [table]) | `length` → [int]
  - the number of rows

It doesn't work on [record]s and [string]s

## lines

same as `split row "\n"`

- (s: [string]) | `lines` → [list]<[string]>

flags

- `-s`: skip empty lines

## math

All the scalar functions also work on lists. They work like `map` function.

Eg: `[1 -1 1 -1] | math abs` is `[1 1 1 1]`

### scalar functions

- (n: [int] | [float]) | `math abs` → [int] | [float]
- (n: [int] | [float]) | `math ceil` → [int]
- (n: [int] | [float]) | `math floor` → [int]
- (n: [int] | [float]) | `math round` → [int] | [float]
- (n: [int] | [float]) | `math sqrt` → [int] | [float]

flags

- `-p` (precision: [int] | [float]): precision of `round`

### logarithms

- (n: [int] | [float]) | `math ln` → [int] | [float]
- (n: [int] | [float]) | `math log` (base: [int] | [float]) → [int] | [float]

### trigonometric functions

- (n: [int] | [float]) | `math arccos` → [float]
- (n: [int] | [float]) | `math arccosh` → [float]
- (n: [int] | [float]) | `math arcsin` → [float]
- (n: [int] | [float]) | `math arcsinh` → [float]
- (n: [int] | [float]) | `math arctan` → [float]
- (n: [int] | [float]) | `math arctanh` → [float]
- (n: [int] | [float]) | `math cos` → [float]
- (n: [int] | [float]) | `math cosh` → [float]
- (n: [int] | [float]) | `math sin` → [float]
- (n: [int] | [float]) | `math sinh` → [float]
- (n: [int] | [float]) | `math tan` → [float]
- (n: [int] | [float]) | `math tanh` → [float]

flags

- `-d`: degrees instead of radians

### functions on a list

- (l: [list]<[int] | [float]>) | `math avg` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math max` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math median` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math min` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math mode` → [list]<[int] | [float]>
  - most frequent element(s)
- (l: [list]<[int] | [float]>) | `math product` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math stddev` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math sum` → [int] | [float]
- (l: [list]<[int] | [float]>) | `math variance` → [int] | [float]

### constants

- `math e` → [float]
  - 2.718281828459045
- `math pi` → [float]
  - 3.141592653589793
- `math tau` → [float]
  - [[math]]2 times pi[[/math]]

## merge

- (r: [record]) | `merge` (val: [record]) → [record]
  - if `r` and `val` has overlapping keys, the values of `val` are chosen
- (t: [table]) | `merge` (val: [table]) → [table]
  - merge row by row

## open

It can read some formats (json, toml, ...). It creates nu-data types for those formats. It returns [string] otherwise.

- (path: [string]) | `open` → any
- `open` (path: [string]) → any

- `-r`: open file as a raw binary

## path

### path basename

- (p: [string]) | `path basename` → [string]
  - 'a/b/c/d.e' → 'd.e'

flags

- `-r` (new_name: [string]): return the original path with basename replaced with this string

### path dirname

- (p: [string]) | `path dirname` → [string]
  - 'a/b/c/d.e' → 'a/b/c'

flags

- `-r` (new_name: [string]): return the original path with dirname replaced with this string
- `-n` (level: [int]): number of directories to walk up

### path exists

- (p: [string]) | `path exists` → [bool]

### path join

- (l: [list]<[string]>) | `path join` → [string]
  - `l` is a result of [path split](#path-split)
- (t: [table]) | `path join` → [string]
  - `t` is a result of [path parse](#path-parse)
- (p: [string]) | `path join` (additional_path: [string]) → [string]

### path parse

- (p: [string]) | `path parse` → [record]

### path split

- (p: [string]) | `path split` → [list]<[string]>

## print

no inputs, no outputs

- `print` (value: any)*

flags

- `-e`: print to stderr
- `-n`: no newlines

## random

### random bool

- `random bool` → [bool]

flags

- `-b` (bias: [float]): probability of a `true` outcome

### random chars

- `random chars` → [string]
  - [0-9a-zA-Z]+

flags

- `-l`: length of the result (default 25)

### random decimal

- `random decimal` (range: [range][typerange]<[float]>) → [float]
  - default range is 0.0 ~ 1.0

### random dice

- `random dice` → [list]<[int]>

flags

- `-d` (dice: [int]): the amount of dices being rolled
- `-s` (sides: [int]): the amount of sides a dice has
  - TODO: there's a typo in the help message

### random integer

- `random integer` (range: [range][typerange]<[int]> = (0..2^63^)) → [int]

### random uuid

[UUID4](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random))

- `random uuid` → [string]

[[anchor, id = command range]][[/anchor]]
## range

- (l: [list]<T>) | `range` (range: [range][typerange]<[int]>) → [list]<T>
  - a range may have negative indexes
- (t: [table]) | `range` (range: [range][typerange]<[int]>) → [table]
  - it works on rows

## reduce

- (l: [list]<T>) | `reduce` (func: [closure]\(T, U) → U) → U
- (t: [table]) | `reduce` (func: [closure]\(Row, U) → U) → U

flags

- `-f` (value: U): initial value

examples

- `[{}, [a, 2], [b, 4], [c, 8]] | reduce {|it, acc| $acc | insert ($it | get 0) ($it | get 1)}` → `{a: 2, b: 4, c: 8}`
- `[[a, 2], [b, 4], [c, 8]] | reduce -f {} {|it, acc| $acc | insert ($it | get 0) ($it | get 1)}` → `{a: 2, b: 4, c: 8}`
- `ls | reduce -f "" {|row res| $res + $row.name}` → `DesktopDocumentsDownloadsMusicPicturesPublicTemplatesVideossnap`

## reject

- (t: [table]) | `reject` (column: ColumnName)* → [table]
  - returns a table without `column`s
- (r: [record]) | `reject` (column: ColumnName)* → [record]
  - returns a record without `column`s

## reverse

- (l: [list]<any>) | `reverse` → [list]<any>
- (t: [table]) | `reverse` → [table]
  - reverses the rows

## save

- (data: any) | `save` (path: [string])

flags

- `-a`: append input to the end of the file
- `-f`: overwrite

## select

- (r: [record]) | `select` (column: ColumnName)* → [record]
  - selects 1 or more columns
- (t: [table]) | `select` (column: ColumnName)* → [table]
  - selects 1 or more columns

## skip

see [drop](#drop) and [first](#first)

- (l: [list]<T>) | `skip` (count: [int] = 1) → [list]<T>
  - skips the first `count` elements
- (t: [table]) | `skip` (count: [int] = 1) → [table]
  - skips the first `count` rows

### skip until

- (l: [list]<T>) | `skip until` (predicate: [closure]\(T) → [bool]) → [list]<T>
  - skips elements of `l` while `predicate` is false
- (t: [table]) | `skip until` (predicate: [closure]\(Row) → [bool]) → [table]
  - skips rows of `t` while `predicate` is false

### skip while

- (l: [list]<T>) | `skip while` (predicate: [closure]\(T) → [bool]) → [list]<T>
  - skips elements of `l` while `predicate` is true
- (t: [table]) | `skip while` (predicate: [closure]\(Row) → [bool]) → [table]
  - skips rows of `t` while `predicate` is true

## sleep

- `sleep` (duration: [duration])

## sort

- (l: [list]<T>) | `sort` → [list]<T>
- (r: [record]) | `sort` → [record]
  - sorts by key

flags

- `-i`: ignores case
- `-n`: "10" is greater than "9"
- `-r`: reverse
- `-v`: (for a single record), sorts by values rather than keys

## sort-by

It seems to be a stable sort

- (t: [table]) | `sort-by` (column: ColumnName)

flags

- `-i`: ignores case
- `-n`: "10" is greater than "9"
- `-r`: reverse
- `-v`: (for a single record), sorts by values rather than keys

## split

### split chars

- (s: [string]) | `split chars` → [list]<[string]>

### split column

- (s: [string]) | `split column` (delim: [string]) → [table]
  - the result contains only one row
  - each column of the row is a separated string
- (strings: [list]<[string]>) | `split column` (delim: [string]) → [table]
  - each row is a result of `split column` on each element of `strings`

### split list

- (l: [list]<T>) | `split list` (delim: T) → [list]<[list]<T>>

### split row

- (s: [string]) | `split row` (delim: [string]) → [list]<[string]>

## str

### str cases

- (s: [string]) | `str camel-case` → [string]
- (s: [string]) | `str capitalize` → [string]
- (s: [string]) | `str downcase` → [string]
- (s: [string]) | `str kebab-case` → [string]
- (s: [string]) | `str pascal-case` → [string]
- (s: [string]) | `str screaming-snake-case` → [string]
- (s: [string]) | `str snake-case` → [string]
- (s: [string]) | `str title-case` → [string]
- (s: [string]) | `str upcase` → [string]

### str contains

- (s: [string]) | `str contains` (substring: [string]) → [bool]

flags

- `-i`: ignore case

### str ends-with

- (s: [string]) | `str ends-with` (substring: [string]) → [bool]

flags

- `-i`: ignores case

### str index-of

- (s: [string]) | `str index-of` (substring: [string]) → [int]
  - returns start index of the first occurence of `substring`
  - returns -1 if not found

flags

- `-b`: counts indexes in bytes (default)
- `-e`: searches from the end
- `-g`: counts indexes in chars

### str join

- (s: [list]<[string]>) | `str join` (delim: [string] = "") → [string]

### str length

- (s: [string]) | `str length` → [int]
  - length in bytes, not in chars

flags

- `-b`: counts length in bytes (default)
- `-g`: counts length in chars

### str replace

TODO

### str reverse

- (s: [string]) | `str reverse` → [string]

### str starts-with

- (s: [string]) | `str starts-with` (substring: [string]) → [bool]

flags

- `-i`: ignores case

### str substring

- (s: [string]) | `str substring` (range: [range][typerange]) → [string]
  - the start of the range is included, but the end is excluded
  - an index may be 0

flags

- `-b`: counts indexes in bytes (default)
- `-g`: counts indexes in chars

### str trim

- (s: [string]) | `str trim` → [string]

flags

- `-a`: trims both sides and in the middle
- `-b`: trims both sides
- `-c` (char: [string]): characters to trim (default: " ")
- `-f`: trims in the middle
- `-l`: trims the left side
- `-r`: trims the right side

## take

- (l: [list]<T>) | `take` (count: [int]) → [list]<T>
  - takes the first `count` elements from `l`
- (t: [table]) | `take` (count: [int]) → [table]
  - takes the first `count` rows from `t`

### take until

- (l: [list]<T>) | `take until` (predicate: [closure]\(T) → [bool]) → [list]<T>
  - takes elements while `predicate` is false
- (t: [table]) | `take until` (predicate: [closure]\(Row) → [bool]) → [table]
  - takes rows while `predicate` is false

### take while

- (l: [list]<T>) | `take while` (predicate: [closure]\(T) → [bool]) → [list]<T>
  - takes elements while `predicate` is true
- (t: [table]) | `take while` (predicate: [closure]\(Row) → [bool]) → [table]
  - takes rows while `predicate` is true

## to

### to html

- (t: [table]) | `to html` → [string]
  - `<table>`
- (l: [list]<any>) | `to html` → [string]
  - `<ol>`
- (r: [record]) | `to html` → [string]
  - a [record] is a [table] with a single row

flags

- `-p`: only output the html for the content itself (no `<body>`, `<html>`, ...)

### to json

- (t: [table]) | `to json` → [string]
  - an array of objects
- (l: [list]<any>) | `to json` → [string]
  - an array
- (r: [record]) | `to json` → [string]
  - an object

flags

- `-i` (indent: [int]): indentation width
- `-r`: remove whitespaces

### to md

- (t: [table]) | `to md` → [string]
  - gfm styled table
- (r: [record]) | `to md` → [string]
  - a [record] is a [table] with a single row

flags

- `-p`: prettify the markdown table

## uniq

- (l: [list]<any>) | `uniq` → [list]<any>
  - removes duplicate elements (leaves only 1)
- (t: [table]) | `uniq` → [table]
  - removes duplicate rows (leaves only 1)

flags

- `-c`: returns a table containing the distinct input values together with their counts
- `-d`: removes unique elements/rows
- `-i`: ignores cases
- `-u`: removes duplicate elements/rows
  - default option leaves 1 element/row, but it removes all

## uniq-by

see [uniq](#uniq)

- (t: [table]) | `uniq-by` (c: ColumnName) → [table]

flags

- `-c`: returns a table containing the distinct rows together with their counts
- `-d`: removes unique rows
- `-i`: ignores cases
- `-u`: removes duplicate rows
  - default option leaves 1 row, but it removes all

## update

see [upsert]

it panics when the field does not exist

- (r: [record]) | `upsert` (key: any) (value: any) → [record]
- (t: [table]) | `upsert` (key: any) (value: any) → [table]
  - all the cells of the updated/inserted column have the same value
- (l: [list]<T>) | `upsert` (index: [int]) (value: T) → [list]<T>
  - it updates `l` by replacing the original value

## upsert

see [insert] and [update]

- (r: [record]) | `upsert` (key: any) (value: any) → [record]
- (t: [table]) | `upsert` (key: any) (value: any) → [table]
  - all the cells of the updated/inserted column have the same value
- (l: [list]<T>) | `upsert` (index: [int]) (value: T) → [list]<T>
  - it updates `l` by replacing the original value

## values

see [columns](#columns)

- (t: [table]) | `values` → [list]<any>
  - returns the values in a list
- (r: [record]) | `values` → [list]<any>
  - returns the values in a list

## wrap

- (l: [list]<any>) | `wrap` (column_name: [string]) → [table]
  - make `l` a column of a [table]

## zip

- (l1: [list]<T>) | `zip` (l2: [list]<U>) → [list]<\[U, V]>
  - the length of the result is `min(l1.len, l2.len)`

[comrange]: #commandrange
[typerange]: #typerange

[comdate]: #commanddate
[typedate]: #typedate

[insert]: #insert
[update]: #update
[upsert]: #upsert

[binary]: #typebinary
[bool]: #typebool
[closure]: #typeclosure
[duration]: #typeduration
[float]: #typefloat
[filesize]: #typefilesize
[int]: #typeint
[list]: #typelist
[null]: #typenull
[record]: #typerecord
[string]: #typestring
[table]: #typetable

# Custom Commands

## aliases

| alias  | explanation        |
|--------|--------------------|
| py     | python3            |
| ll     | launcher           |
| gnt    | gnome-text-editor  |

## battery

- `battery` → [record]

flags

- `-v`: verbose output

## birthday

- `birthday` → [date][typedate]
  - 1999.01.20

## extract

- `extract` (path: [string])

## render_doc

use my engine to render a markdown file

- `render_doc` (path: [string])

## up

- `up` (level: [int])
  - go up `level` times

TODO: function signatures of `first` and `last` don't tell us that they work on tables.

TODO: people (developers) are complaining that `first n` and `take` are doing the same thing. So they might change the API soon. Let's keep an eye on it.
