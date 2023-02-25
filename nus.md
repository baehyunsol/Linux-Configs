nushell 0.76.0

[[toc]]

# Basic Types

## closure

{|x| $x + 1}, {$in + 1}

## float

TODO

## int

64bit signed integer

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

# Basic Commands

## Arithmatic Operations

- (lhs: [list]<any>) `++` (rhs: [list]<any>) -> [list]<any>
- (lhs: [string]) `+` (rhs: [string]) -> [string]
- (l: [list]<any>) `*` (times: [int]) -> [list]<any>
- (s: [string]) `*` (times: [int]) -> [string]
- (base: [int]) `**` (exp: [int]) -> [int]
- (base: [int] | [float]) `**` (exp: [int] | [float]) -> [float]

## columns

see [values]

- (t: [table]) | `columns` -> [list]<[string]>
  - returns the names of the columns in `list<string>`
- (r: [record]) | `columns` -> [list]<[string]>
  - returns the names of the columns in `list<string>`

## each

- (l: [list]<T>) | `each` (func: [closure]\(T) -> U) -> [list]<U>
  - if `func` returns null, it skips the index
  - in order to include nulls, `-k` flag must be given
- (t: [table]) | `each` (func: [closure]\(T) -> U) -> [list]<U>
  - `T` is the type of `t`'s row
  - the length of the result is the number of the rows, that means `func` is applied to "each" row

- `-k`: keep empty (null) value cells

## enumerate

TODO

## filter

- (l: [list]<T>) | `filter` (predicate: [closure]\(T) -> [bool]) -> [list]<T>
- (t: [table]) | `filter` (predicate: [closure]\(R) -> [bool]) -> [table]
  - `R` is a row of `t`

## get

- (t: [table]) | `get` (n: [int]) -> [record]
  - get `n`th row of `t`
- (t: [table]) | `get` (k: T) -> [list]
  - get column with key `k` in `t`
- (l: [list]<T>) | `get` (n: [int]) -> T
  - get `n`th element of `l`
- (r: [record]) | `get` (k: any) -> V
  - key-value search

## length

- (l: [list]<any>) | `length` -> [int]
- (t: [table]) | `length` -> [int]
  - the number of rows

It doesn't work on [record]s and [string]s.

## random

### random bool

- `random bool` -> [bool]

- `-b` (bias: [float]): probability of a `true` outcome

### random chars

TODO

TODO: enhance help message (default length)

### random decimal

TODO

TODO: enhance help message (default range)

### random dice

TODO

### random integer

TODO

### random uuid

TODO

## range

TODO

## reverse

TODO

## select

- (r: [record]) | `select` (column: ColumnName)* -> [record]
  - selects 1 or more columns
- (t: [table]) | `select` (column: ColumnName)* -> [table]
  - selects 1 or more columns

## sort

- (l: [list]<T>) | `sort` -> [list]<T>
- (r: [record]) | `sort` -> [record]
  - sort by key

- `-r`: reverse
- `-i`: ignore case
- `-n`: "10" is greater than "9"
- `-v`: (for a single record), sort by values rather than keys

## sort-by

- (t: [table]) | `sort-by` (column: c)
  - `column` must be a valid column of `t`

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

- `-i`: ignore case (not implemented yet)

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

- `-i`: ignore case (not implemented yet)

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

## uniq

TODO

## values

see [columns]

- (t: [table]) | `values` -> [list]<any>
  - returns the values in a list
- (r: [record]) | `values` -> [list]<any>
  - returns the values in a list

# Custom Commands
