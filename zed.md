# Performance

It feels faster than VSCode, but to be honest, VSCode is fast enough.

# UI/UX

## Auto-remove trailing whitespace

It removes trailing whitespace when I save a file. At first I thought it was a bug, but it's a feature!

I'll disable it anyway. It's not compatible with my philosophy: "Do a thing only when asked to do so.". There're many things to disable.

```json
{
  "ensure_final_newline_on_save": false,
  "format_on_save": "off",
  "remove_trailing_whitespace_on_save": false
}
```

They're lacking a consistency...

Still, I want a shortcut that does the 3 things above.

## Invoking from CLI

Like VSCode, I have to manually add a symbolic link to a bin directory. There's a catch. There're 3 binaries in `/Applications/Zed.app/Contents/MacOS`. You have to choose `cli`, not `zed`. `zed` doesn't allow opening multiple instances. Also, I have to test this on Linux.

## Line height

Its default terminal line height is too big. I have added below lines to `~/.config/zed/settings.json`.

```json
{
  "terminal": {
    "line_height": {
      "custom": 1.1
    }
  }
}
```

## Word Wrap

```json
{
  "preferred_line_length": 20000,
  "soft_wrap": "preferred_line_length",
  "languages": {
    "Markdown": {
      "soft_wrap": "editor_width"
    }
  }
}
```

This is my config after using zed for 3 hours. It allows me to see the entire content of markdown files without scrolling horizontally. Otherwise, it shows line by line.

What it's lacking is

1. Toggle word wrap option with a key (maybe I can create one)
2. Prevent word wrapping however long a line is (maybe due to a performance reason?)

## Language Servers

I found the default-enabled Python/Rust language extension so annoying. I disabled it by

```json
{
  "languages": {
    "Python": {
      "language_servers": []
    },
    "Rust": {
      "language_servers": []
    }
  }
}
```

# Git integration

- Line history by default
  - Shows the last commit that edited the selected line.
  - I need "Git Lens" extension on VSCode to do this.
- Color git diffs
  - New lines are green, edited lines are yellow, and removed lines are red.
  - Colors are slightly different but the behavior is the same.

# AI Integration

- I can use my own API keys. I really like this.
- Automatic code suggestion is off by default.
- I'm using Gpt-4o with zed, and it feels like zed's code completion is more stupid than VSCode's. Maybe we need more prompt engineering.
- What's even better is that zed's assistant is fully open source. I'll read the prompts someday. If I know how the assistant work, I can utilize it much better!

# Keys

- Opt + backslash to "Split Right" (Same as VSCode)
- Opt + slash to "Comment Out" (Same as VSCode)
- Opt + D to "multiselect" (Same as VSCode)
  - The problem is that I don't know how to toggle case sensitivity. But I'll find that out soon.
  - I'm so glad that the feature that I love the most is here!
- Ctrl + backtick to "Open Terminal" (Same as VSCode)
  - It doesn't work when the Input Language is Korean (Same as VSCode). I guess it's an macOS' issue.
  - There're Ctrl + backtick and Opt + J that open/close the terminal. Their behavior is a bit different from that of VSCode.
    - Ctrl + backtick 1) opens terminal if there's no terminal 2) toggles focus if there's a terminal dock
    - Opt + J always toggles the terminal dock. This is the behavior I want from Ctrl + backtick.
    - How about changing configurations to alter the behavior of Ctrl + backtick and Opt + J?
- Opt + Shift + F to "Search All" (Same as VSCode)
  - VSCode's search panel is on the left side, but zed opens a new tab.
  - Both interfaces are good.

# Theme

I'm using `Ayu Dark`, but I'm not 100% satisfied with it. How about creating my own theme?
