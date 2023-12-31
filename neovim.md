# Neovim

I guess vim and neovim have the same behavior.

[[toc]]

## Modes

- Normal mode
  - move around
- Visual mode
  - select a piece of text
- Insert mode
- Terminal mode

Pressing <ESC> in any mode goes to the Normal mode.

## Move around

- hjkl: left, down, up, right 
- w: go to next word
  - word / WORD: A word consists of letters, digits and underscores, while a WORD consists of non-whitespace characters.
- b: go to prev word
- 0/$: go to the first/last character of the current line.
- (/): go to the prev/next sentence
- G: go to the last line
- gg: go to the first line
- {/}: go to prev/next paragraph
- Ctrl+D: scroll downwards
  - It scrolls half-screen by default. You can change that with `:set scroll=X` (X lines)
- Ctrl+U: scroll upwards
  - Same as Ctrl+D, but goes upward.
- ma mb mc ... mz: mark the current position
  - Vim can remember up to 26 positions.
- backtick + a b ... z: go to mark
- `:marks`: see the list of marks.
- %: go to the item that matches the cursor
  - For ex, if the cursor is pointing a `(`, it goes to the closing `)`.

## Search

- `/regex`: searches a pattern in the text.
  - For ex, `/searches` searches for "searches" in the text.
- n/N: go to the next/previous search result.
  - After searching, use n/N to hop between the results.
- `/pat\c` does an case insensitive search, while `/pat\C` is case-sensitive (default).
- two backticks: jump back to the previous position
  - to the position before the searching
- `:noh`: remove the current search highlights.

## Substitution

`:%s/that/what/gc` finds all the occurrences of 'that' and replace that with `what`.

- `%s` means "search and replace on every line". If it were just `s`, it only searches the current line.
- You can use patterns in `that` and `what`... let's not use patterns.
- After the last `/` are flags.
  - `g` flag tells vim to search all the occurrences in a line. Without it, vim only searches the first occurrence in each line.
  - With `c` flag, vim asks you before substituting each occerrence. Press `y` to confirm, press `n` to skip, press `a` to susbstitute all and press ESC to escape.
- By default, it's case-sensitive. To make it case-insensitive, use `i` flag.

You can use Ctrl+Y/Ctrl+E to move the screen upwards/downwards, like in Visual mode!

## Redo / Undo

- u: undo, it's like Ctrl+Z
  - It doesn't work in insert mode. When undone after an insert mode, it discards all the changes in the last insert mode.
- Ctrl+R: redo the change that were undone.

## Insert mode / Replace mode

In Normal mode, press `i`/`a` to enter insert mode at the cursor position, press `o` to insert a line and enter insert mode at the new line, or press `R` to enter replace mode at the cursor position. (It's case sensitive!)

Replace mode is like insert mode, but it deletes a character under the cursor before inserting a character.

- Ctrl+W: Delete a word.
- Ctrl+U: Delete the current line (begining of the line ~ cursor)

## Terminal mode

In normal mode, type `:terminal` to enter terminal mode.

In terminal mode, press `i` to enter terminal-insert mode. Press Ctrl+\\ Ctrl+N to enter terminal-normal mode.

## Visual mode

In normal mode, press `v` to enter visual mode. In visual mode, you can select a piece of text.

- h/j/k/l/w/b/G/gg: like in normal mode, but it changes the selection 
- as: select till the next sentence.
- Ctrl+Y/Ctrl+E: move the screen (not the cursor) upwards/downwards.
- x: Delete the selected text and yank that to a register. It's like Ctrl+X in VS code.
  - You can specify a register, like `"ax`. The register is `""` by default.
- y: Yank the selected text. It's like Ctrl+C in VS code.
  - You can speicfy a register, like `"ay`. The register is `""` by default.
- u/U: make the selected text lowercase/uppercase.

## Copy / Paste

Vim uses different terms: Yank/Put instead of Copy/Paste. It has multiple registers each of which can store a piece of text.

- `:reg`: see the contents of the registers.
- p: paste the content of a register. 
  - You can specify a register, like `"ap`. The register is `""` by default.
- yy: yank the current line.
  - You can specify a register, like `"ayy`. The register is `""` by default.
- dd: Delete the current line and yank the content to a register.
  - You can specify a register, like `"add`. The register is `""` by default.

## Misc

- `:ascii`: print the ascii value of the character the cursor is pointing.
- `:history`: shows you the coloned command you have typed so far.
- `:set guifont=mono:h11`
  - set gui font `mono`, and the font size 11.
- `:w`: save
- `:q`: quit
- `:q!`: force quit
- `:set number`/`:set number!`: turn on/off line number
  - use `relativenumber` instead of `number` to show relative line numbers.

## Window

When multiple windows are open...

- Ctrl+W [N] '+': Increase the current window height by N.
- Ctrl+W [N] '-': Decrease the current window height by N.
- Ctrl+W [N] '>': Increase the current window width by N.
- Ctrl+W [N] '<': Decrease the current window width by N.
- Ctrl+W [N] '=': Make the size of all the windows the same.
- Ctrl+W [N] 'h'/'j'/'k'/'l': Go N windows left/down/up/right.
- Ctrl+W 'r': Rotate the windows downwards/rightwards.
- Ctrl+W 'R': Rotate the windows upwards/leftwards.
- Ctrl+W [M] '|'/'\_': Make the current window widest/highest possible. With [M] given, you can specify the width/height of the current window.

For all commands with [N], you can omit N. When omitted, N is 1 by default.

- `:close`: Close the current window.
- `:only`: Close all the windows but the current window.

To split a window...

- Ctlr+W 's'/'v': Split the current window horizontally/vertically.

TODO: make a macro: Ctrl+W l, Ctrl+W |  -> focus the next window

## Tabs

- `:tabnew [FILE]`: open FILE in a new tab.
  - if FILE is not given, it opens an empty tab.
- Ctrl+W 'T': move the current window to a new tab
- gt: go to next tab
  - [N] gt: goes to Nth tab
- gT: go to previous tab
- `:tabc(lose)`, `:tabo(nly)`, `:tabm(ove) [N]`
- `:tabl(ast)`, `:tabfir(st)`
- g <Tab>: go to the previously accessed tab

## Things to investigate

Run code, like Ctrl+\` in VSCode.

Resize font size, like Ctrl+`+`/`-` in VSCode.

