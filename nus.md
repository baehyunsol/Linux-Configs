nushell 0.76.0

[[toc]]

# Basic Types

## closure

{|x| $x + 1}, {$in + 1}

## float

64 bits double precision floating point number (I guess)

## int

64 bits signed integer

TODO: `0x[1000]`

## list

untyped data structure, use json-style syntax

## record

key-value data structure, use json-style syntax

## table

each row is a record, and each column is a list. if the rows have different types... don't just do that

[[box]]

TODO: 이거 어디에 적지...

`if c { d }` is an expression that returns null when `c` is not true

[[/box]]

# Arithmatic Operations

- (lhs: [list]<any>) `++` (rhs: [list]<any>) -> [list]<any>
- (lhs: [string]) `+` (rhs: [string]) -> [string]
- (l: [list]<any>) `*` (times: [int]) -> [list]<any>
- (s: [string]) `*` (times: [int]) -> [string]
- (base: [int]) `**` (exp: [int]) -> [int]
- (base: [int] | [float]) `**` (exp: [int] | [float]) -> [float]

# Basic Commands

## all

- (l: [list]<T>) | `all` (predicate: [closure]\(T) -> [bool]) -> [bool]
- (t: [table]) | `all` (predicate: [closure]\(R) -> [bool]) -> [bool]
  - `R` is a row of `t`

## any

- (l: [list]<T>) | `any` (predicate: [closure]\(T) -> [bool]) -> [bool]
- (t: [table]) | `any` (predicate: [closure]\(R) -> [bool]) -> [bool]
  - `R` is a row of `t`

## columns

see [values]

- (t: [table]) | `columns` -> [list]<[string]>
  - returns the names of the columns in `list<string>`
- (r: [record]) | `columns` -> [list]<[string]>
  - returns the names of the columns in `list<string>`

## drop

TODO

## each

- (l: [list]<T>) | `each` (func: [closure]\(T) -> U) -> [list]<U>
  - if `func` returns null, it skips the index
  - in order to include nulls, `-k` flag must be given
- (t: [table]) | `each` (func: [closure]\(T) -> U) -> [list]<U>
  - `T` is the type of `t`'s row
  - the length of the result is the number of the rows, that means `func` is applied to "each" row

- `-k`: keep empty (null) value cells

## enumerate

- (t: [table]) | `enumerate` -> [table]<index: [int], item: Row>
- (l: [list]<T>) | `enumerate` -> [table]<index: [int], item: T>
- (r: [record]) | `enumerate` -> [table]<index: [int], item: [record]>
  - A record works like a table with a single row

It doesn't work on strings

## filter

- (l: [list]<T>) | `filter` (predicate: [closure]\(T) -> [bool]) -> [list]<T>
- (t: [table]) | `filter` (predicate: [closure]\(R) -> [bool]) -> [table]
  - `R` is a row of `t`

## first

see [last]

- (l: [list]<T>) | `first` -> T
- (l: [list]<T>) | `first` (n: [int]) -> [list]<T>
  - returns a list with the first `n` elements

TODO: `first` on binary data

## get

- (t: [table]) | `get` (n: [int]) -> [record]
  - get `n`th row of `t`
- (t: [table]) | `get` (k: T) -> [list]
  - get column with key `k` in `t`
- (l: [list]<T>) | `get` (n: [int]) -> T
  - get `n`th element of `l`
- (r: [record]) | `get` (k: any) -> V
  - key-value search

## into

### into binary

TODO

### into bool

- (n: [int] | [float]) | `into bool` -> [bool]
  - non-zero for true
- (b: [bool]) | `into bool` -> [bool]
- (s: [string]) | `into bool` -> [bool]
  - `s` should be a valid representation of a boolean or a number
- (l: [list]<any>) | `into bool` -> [list]<[bool]>
  - `each {$in | into bool}`

### into datetime

TODO

### into decimal

TODO

### into duration

TODO

### into filesize

TODO

### into int

TODO

### into record

TODO

### into sqlite

TODO

### into string

- any | `into string` -> [string]

- `-d` (digits: [int]): decimal digits to which to round (only for numerics)

## last

see [first]

- (l: [list]<T>) | `last` -> T
- (l: [list]<T>) | `last` (n: [int]) -> [list]<T>
  - returns a list with the last `n` elements

## length

- (l: [list]<any>) | `length` -> [int]
- (t: [table]) | `length` -> [int]
  - the number of rows

It doesn't work on [record]s and [string]s

## random

### random bool

- `random bool` -> [bool]

- `-b` (bias: [float]): probability of a `true` outcome

### random chars

- `random chars` -> [string]
  - [0-9a-zA-Z]+

- `-l`: length of the result (default 25)

### random decimal

TODO: type에도 range 있고, 명령어 중에도 range 있음! 링크 이름 안 겹치게 잘 하셈..!!

- `random decimal` (range: [range]<[float]>) -> [float]
  - default range is 0.0 ~ 1.0

### random dice

TODO

### random integer

TODO: type에도 range 있고, 명령어 중에도 range 있음! 링크 이름 안 겹치게 잘 하셈..!!

- `random integer` (range: [range]<[int]> = (0..2^63^)) -> [int]

### random uuid

TODO

## range

TODO

## reduce

TODO

## reject

TODO

## reverse

- (l: [list]<any>) | `reverse` -> [list]<any>
- (t: [table]) | `reverse` -> [table]
  - reverse the rows

## select

- (r: [record]) | `select` (column: ColumnName)* -> [record]
  - selects 1 or more columns
- (t: [table]) | `select` (column: ColumnName)* -> [table]
  - selects 1 or more columns

## skip

TODO

### skip until

TODO

### skip while

TODO

## sort

- (l: [list]<T>) | `sort` -> [list]<T>
- (r: [record]) | `sort` -> [record]
  - sort by key

- `-r`: reverse
- `-i`: ignore case
- `-n`: "10" is greater than "9"
- `-v`: (for a single record), sort by values rather than keys

## sort-by

It seems to be a stable sort

- (t: [table]) | `sort-by` (column: ColumnName)

- `-r`: reverse
- `-i`: ignore case
- `-n`: "10" is greater than "9"
- `-v`: (for a single record), sort by values rather than keys

## split

### split chars

- (s: [string]) | `split chars` -> [list]<[string]>

### split column

- (s: [string]) | `split column` (delim: [string]) -> [table]
  - the result contains only one row
  - each column of the row is the separated strings
- (strings: [list]<[string]>) | `split column` (delim: [string]) -> [table]
  - each row is a result of `split column` on each element of `strings`

### split list

- (l: [list]<T>) | `split list` (delim: <T>) -> [list]<[list]<T>>

### split row

- (s: [string]) | `split row` (delim: [string]) -> [list]<[string]>

## str

### str cases

- (s: [string]) | `str camel-case` -> [string]
- (s: [string]) | `str capitalize` -> [string]
- (s: [string]) | `str downcase` -> [string]
- (s: [string]) | `str kebab-case` -> [string]
- (s: [string]) | `str pascal-case` -> [string]
- (s: [string]) | `str screaming-snake-case` -> [string]
- (s: [string]) | `str snake-case` -> [string]
- (s: [string]) | `str title-case` -> [string]
- (s: [string]) | `str upcase` -> [string]

### str contains

- (s: [string]) | `str contains` (substring: [string]) -> [bool]

- `-i`: ignore case

### str ends-with

- (s: [string]) | `str ends-with` (substring: [string]) -> [bool]

- `-i`: ignore case

### str index-of

- (s: [string]) | `str index-of` (substring: [string]) -> [int]
  - returns start index of the first occurence of `substring`
  - returns -1 if not found

- `-b`: count indexes in bytes (default)
- `-e`: search from the end
- `-g`: count indexes in chars

### str join

- (s: [list]<[string]>) | `str join` (delim: [string] = "") -> [string]

### str length

- (s: [string]) | `str length` -> [int]
  - length in bytes, not in chars

- `-b`: count length in bytes (default)
- `-g`: count length in chars

### str replace

TODO

### str reverse

- (s: [string]) | `str reverse` -> [string]

### str starts-with

- (s: [string]) | `str starts-with` (substring: [string]) -> [bool]

- `-i`: ignore case

### str substring

TODO: type에도 range 있고, 명령어 중에도 range 있음! 링크 이름 안 겹치게 잘 하셈..!!

- (s: [string]) | `str substring` (range: [range]) -> [string]
  - the start of the range is included, but the end is excluded
  - an index may be 0

- `-b`: count indexes in bytes (default)
- `-g`: count indexes in chars

### str trim

- (s: [string]) | `str trim` -> [string]

- `-a`: trims both sides and in the middle
- `-b`: trims both sides
- `-c` (char: [string]): characters to trim (default: " ")
- `-f`: trims in the middle
- `-l`: trims the left side
- `-r`: trims the right side

## take

TODO

### take until

TODO

### take while

TODO

## uniq

- (l: [list]<any>) | `uniq` -> [list]<any>
  - removes duplicate elements (leaves only 1)
- (t: [table]) | `uniq` -> [table]
  - removes duplicate rows (leaves only 1)

- `-c`: returns a table containing the distinct input values together with their counts
- `-d`: removes unique elements/rows
- `-i`: ignore cases
- `-u`: removes duplicate elements/rows
  - default option leaves 1 element/row, but it removes all

## uniq-by

see [uniq]

- (t: [table]) | `uniq-by` (c: ColumnName) -> [table]

- `-c`: returns a table containing the distinct rows together with their counts
- `-d`: removes unique rows
- `-i`: ignore cases
- `-u`: removes duplicate rows
  - default option leaves 1 row, but it removes all

## values

see [columns]

- (t: [table]) | `values` -> [list]<any>
  - returns the values in a list
- (r: [record]) | `values` -> [list]<any>
  - returns the values in a list

# Custom Commands
